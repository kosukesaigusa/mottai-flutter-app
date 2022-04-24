import 'dart:convert';
import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../constants/string.dart';
import '../../models/firebase/firebase_task_result.dart';

final authRepository = Provider.autoDispose((ref) => AuthRepository());

class AuthRepository {
  AuthRepository();

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// ログイン済みかつ CustomClaims のアドミンユーザーかどうか
  Future<bool> get isAdminUser async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    final idTokenResult = await user.getIdTokenResult(true);
    return (idTokenResult.claims?['isAdmin'] ?? false) as bool;
  }

  /// メールアドレスとパスワードによるサインイン
  Future<FirebaseTaskResult<UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseTaskResult<UserCredential>.success(
        contents: userCredential,
        message: 'サインインしました。',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: 'そのアカウントはご使用になれません。',
          code: e.code,
        );
      } else if (e.code == 'user-not-found') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: '入力されたメールアドレスのユーザーは見つかりません。',
          code: e.code,
        );
      } else if (e.code == 'wrong-password') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: 'パスワードが正しくありません。',
          code: e.code,
        );
      } else if (e.code == 'too-many-requests') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: '認証失敗の回数が一定を超えました。'
              'しばらくして再度サインインしてください。',
          code: e.code,
        );
      } else {
        return FirebaseTaskResult<UserCredential>.failure(
          message: generalErrorMessage,
          code: e.code,
        );
      }
    }
  }

  /// Google でサインインする。
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw Exception();
      }
      final googleSignInAuthentication = await googleSignInAccount.authentication;
      final oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final userCredential = await _signInWithOAuthCredential(oAuthCredential);
      return AuthResult(
        userCredential: userCredential,
        displayName: googleSignInAccount.displayName,
        imageURL: googleSignInAccount.photoUrl,
      );
    } on PlatformException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// Apple でサインインする。
  Future<AuthResult> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      nonce: nonce,
    );
    try {
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: authorizationCredentialAppleID.identityToken,
        rawNonce: rawNonce,
      );
      final userCredential = await _signInWithOAuthCredential(oAuthCredential);
      return AuthResult(
        userCredential: userCredential,
        appleUserIdentifier: authorizationCredentialAppleID.userIdentifier,
        displayName: _getJapaneseFullName(
          familyName: authorizationCredentialAppleID.familyName,
          givenName: authorizationCredentialAppleID.givenName,
        ),
      );
    } on PlatformException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// LINE でサインインする。
  /// LINE ログインで得られた アクセストークンと ID トークンとを使用して
  /// Callable Functions をコールして Firebase Auth の Custom Token を取得して
  Future<AuthResult> signInWithLINE() async {
    try {
      final result = await LineSDK.instance.login(scopes: ['profile', 'openid', 'email']);
      final userProfile = result.userProfile;
      if (userProfile == null) {
        return AuthResult(userCredential: null);
      }
      final accessToken = result.accessToken.data['access_token'] as String;
      final idToken = (result.data['accessToken'] as Map<String, dynamic>)['id_token'] as String;
      final customToken =
          await _createFirebaseAuthCustomToken(accessToken: accessToken, idToken: idToken);
      final userCredential = await _signInWithCustomToken(customToken);
      return AuthResult(
        userCredential: userCredential,
        displayName: userProfile.displayName,
        imageURL: userProfile.pictureUrl,
      );
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.code == '3003' ? 'キャンセルしました。' : 'エラーが発生しました。',
      );
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// Google や Apple ログインを通じた OAuthCredential を受け取ってサインインする。
  /// ログイン済みだった場合には、そのログイン済みのユーザーにリンクする。
  Future<UserCredential> _signInWithOAuthCredential(OAuthCredential oAuthCredential) async {
    final user = _auth.currentUser;
    try {
      final userCredential = user == null
          ? await _auth.signInWithCredential(oAuthCredential)
          : await user.linkWithCredential(oAuthCredential);
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } on PlatformException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// カスタムトークン認証でサインインする。
  /// 既存のユーザーにカスタムトークン認証のユーザーを結びつけるのは容易ではなさそう。
  /// 参考：
  /// https://stackoverflow.com/questions/40171663/linking-custom-auth-provider-with-firebase
  Future<UserCredential?> _signInWithCustomToken(String customToken) async {
    try {
      final userCredential = await _auth.signInWithCustomToken(customToken);
      return userCredential;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// LINE の accessToken から FirebaseAuth の Custom Token を作成するための
  /// Callable Functions をコールする。
  Future<String> _createFirebaseAuthCustomToken({
    required String accessToken,
    required String idToken,
  }) async {
    final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
        .httpsCallable('createFirebaseAuthCustomToken');
    final data = <String, dynamic>{
      'accessToken': accessToken,
      'idToken': idToken,
    };
    try {
      final response = await callable.call<Map<String, dynamic>>(data);
      final channelId = response.data['channelId'] as String;
      final expiresIn = response.data['expiresIn'] as int;
      final customToken = response.data['customToken'] as String;
      // Channel ID の一致と expiresIn が正の数であることを検証する必要がある
      // 参考：
      // https://developers.line.biz/ja/docs/line-login/secure-login-process/#using-access-tokens
      if (channelId != const String.fromEnvironment('LINE_CHANNEL_ID') || expiresIn <= 0) {
        throw Exception();
      }
      return customToken;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 姓・名を合わせてフルネームを返す。
  String _getJapaneseFullName({String? familyName, String? givenName}) {
    if ((familyName ?? '').isEmpty) {
      return givenName ?? '';
    }
    if ((givenName ?? '').isEmpty) {
      return familyName ?? '';
    }
    return '$familyName $givenName';
  }
}
