import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../constants/string.dart';
import '../../controllers/firebase/firebase_task_result.dart';
import '../../controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/enums.dart';

final authRepository = Provider.autoDispose((ref) => AuthRepository(ref.read));

class AuthRepository {
  AuthRepository(this._reader);

  final Reader _reader;

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// ログイン済みかつCustomClaims のアドミンユーザーかどうか
  Future<bool> get isAdminUser async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    final idTokenResult = await user.getIdTokenResult(true);
    return (idTokenResult.claims?['isAdmin'] ?? false) as bool;
  }

  /// メールアドレスとパスワードによるサインイン
  Future<FirebaseTaskResult<UserCredential>> signInWithEmail({
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

  /// Google サインイン
  Future<void> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
        return;
      }
      final googleSignInAuthentication = await googleSignInAccount.authentication;
      final oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      await _storeUserProfileInSharedPreferences(
        signInMethod: SignInMethodEnum.google,
        photoUrl: googleSignInAccount.photoUrl,
        displayName: googleSignInAccount.displayName,
      );
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException {
      rethrow;
    }
    return;
  }

  /// Apple でサインインして、SharedPreferences に名前を保存する。
  Future<void> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    try {
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: authorizationCredentialAppleID.identityToken,
        rawNonce: rawNonce,
      );
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      final currentAppleIdUserIdentifier =
          SharedPreferencesService.sp.getString(SharedPreferencesKey.appleIdUserIdentifier.name);
      final newAppleIdUserIdentifier = authorizationCredentialAppleID.userIdentifier;
      // Apple ID の userIdentifier が変わった時だけ SharedPreferences を上書きする
      if (currentAppleIdUserIdentifier != newAppleIdUserIdentifier &&
          newAppleIdUserIdentifier != null) {
        await _storeUserProfileInSharedPreferences(
          signInMethod: SignInMethodEnum.apple,
          displayName: "${authorizationCredentialAppleID.familyName ?? ''} "
              "${authorizationCredentialAppleID.givenName ?? ''}",
          appleIdUserIdentifier: authorizationCredentialAppleID.userIdentifier,
        );
      }
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
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

  /// SharedPreferences に画像と表示名を保存する
  Future<void> _storeUserProfileInSharedPreferences({
    required SignInMethodEnum signInMethod,
    String? photoUrl,
    String? displayName,
    String? appleIdUserIdentifier,
  }) async {
    await SharedPreferencesService.sp.setString(
      SharedPreferencesKey.lastSignedInMethod.name,
      signInMethod.name,
    );
    if (photoUrl != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.profileImageURL.name,
        photoUrl,
      );
    }
    if (displayName != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.displayName.name,
        displayName,
      );
    }
    if (appleIdUserIdentifier != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.appleIdUserIdentifier.name,
        appleIdUserIdentifier,
      );
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
}
