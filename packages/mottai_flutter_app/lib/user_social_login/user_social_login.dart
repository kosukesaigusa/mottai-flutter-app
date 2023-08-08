import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../auth/auth.dart';
import '../firestore_repository.dart';

/// 指定した [UserSocialLogin] ドキュメントを購読する [StreamProvider].
final userSocialLoginStreamProvider =
    StreamProvider.family.autoDispose<ReadUserSocialLogin?, String>(
  (ref, userId) => ref
      .watch(userSocialLoginRepositoryProvider)
      .subscribeUserSocialLogin(userId: userId),
);

final userSocialLoginServiceProvider =
    Provider.autoDispose<UserSocialLoginService>(
  (ref) => UserSocialLoginService(
    userSocialLoginRepository: ref.watch(userSocialLoginRepositoryProvider),
  ),
);

class UserSocialLoginService {
  const UserSocialLoginService({
    required UserSocialLoginRepository userSocialLoginRepository,
  }) : _userSocialLoginRepository = userSocialLoginRepository;

  final UserSocialLoginRepository _userSocialLoginRepository;

  /// [UserSocialLogin] の作成
  ///
  /// 指定した [SignInMethod] に関連するプロパティのみを `true` とした [UserSocialLogin] を作成する
  Future<void> createUserSocialLogin({
    required String userId,
    required SignInMethod signInMethod,
  }) async {
    switch (signInMethod) {
      case SignInMethod.google:
        await _userSocialLoginRepository.setUserSocialLogin(
          userId: userId,
          isGoogleEnabled: true,
        );
      case SignInMethod.apple:
        await _userSocialLoginRepository.setUserSocialLogin(
          userId: userId,
          isAppleEnabled: true,
        );
      case SignInMethod.line:
        await _userSocialLoginRepository.setUserSocialLogin(
          userId: userId,
          isLINEEnabled: true,
        );
      //TODO emailは追って削除になる想定
      case SignInMethod.email:
        await _userSocialLoginRepository.setUserSocialLogin(
          userId: userId,
        );
    }
  }

  /// ログイン時に生成される `Credential` を元に、ユーザーアカウントにソーシャル認証情報をリンクし、
  /// 指定した [SignInMethod] に関連する [UserSocialLogin] のプロパティを引数で受けた真偽値に更新する
  Future<void> linkUserSocialLogin({
    required SignInMethod signInMethod,
    //TODO userIdは引数で受けるで問題ないか？auth.dartで定義されているProviderから取得すべきか？
    required String userId,
    required bool value,
  }) async {
    await _linkWithCredential(signInMethod: signInMethod);
    await _updateUserSocialLoginSignInMethodStatus(
      signInMethod: signInMethod,
      userId: userId,
      value: value,
    );
  }

  /// ログイン時に生成される `Credential` を元に、ユーザーアカウントにソーシャル認証情報をリンクする
  Future<void> _linkWithCredential({required SignInMethod signInMethod}) async {
    final credential = switch (signInMethod) {
      SignInMethod.google => await _getGoogleCredential(),
      SignInMethod.apple => await _getAppleCredential(),
      SignInMethod.line => await _getLineCredential(),
      //TODO emailは追って削除される想定
      SignInMethod.email => null,
    };
    //TODO FirebaseAuth.instanceをここで再度実行するのは望ましくなさそう？
    //TODO credentialの `!` は追って修正が必要
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential!);
  }

  //TODO 以下のcredential取得系メソッド群はauth.dartと重複している箇所が多いが、問題ないか？

  /// Google認証から [AuthCredential] を取得する
  ///
  /// [GoogleSignIn] ライブラリを使用してユーザーにGoogleでのログインを求め、
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す
  Future<AuthCredential> _getGoogleCredential() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  }

  /// 文字列から `SHA-256` ハッシュを作成する。
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Apple認証から [AuthCredential] を取得する
  ///
  /// Appleでのログインを求める。
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す。
  Future<AuthCredential> _getAppleCredential() async {
    final rawNonce = generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    return OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
  }

  /// LINE認証から [AuthCredential] を取得する
  ///
  /// LINE SDKを使用してユーザーにLINEでのログインを求める。
  /// 成功した場合は、取得したアクセストークンを基にFirebase用のAuthCredentialオブジェクトを生成して返す。
  Future<AuthCredential> _getLineCredential() async {
    final loginResult = await LineSDK.instance.login();
    final accessToken = loginResult.accessToken.data['access_token'] as String;

    return OAuthProvider('line').credential(accessToken: accessToken);
  }

  /// 指定した [SignInMethod] に関連する [UserSocialLogin] のプロパティを、引数で受けた真偽値に更新する
  Future<void> _updateUserSocialLoginSignInMethodStatus({
    required SignInMethod signInMethod,
    required String userId,
    required bool value,
  }) async {
    switch (signInMethod) {
      case SignInMethod.google:
        await _userSocialLoginRepository.updateIsGoogleEnabled(
          userId: userId,
          value: value,
        );
      case SignInMethod.apple:
        await _userSocialLoginRepository.updateIsAppleEnabled(
          userId: userId,
          value: value,
        );
      case SignInMethod.line:
        await _userSocialLoginRepository.updateIsLINEEnabled(
          userId: userId,
          value: value,
        );
      case SignInMethod.email:
      //TODO emailはなくなる？
    }
  }
}
