import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  /// 指定した [SignInMethod] に関連する [UserSocialLogin] のプロパティを、引数で受けた真偽値に更新する
  Future<void> linkUserSocialLogin({
    required AuthCredential credential,
    required SignInMethod signInMethod,
    required String userId,
    required bool value,
  }) async {
    await _linkWithCredential(credential: credential);
    await _updateUserSocialLoginSignInMethodStatus(
      signInMethod: signInMethod,
      userId: userId,
      value: value,
    );
  }

  /// ログイン時に生成される `Credential` を元に、ユーザーアカウントにソーシャル認証情報をリンクする
  Future<void> _linkWithCredential({required AuthCredential credential}) async {
    //TODO FirebaseAuth.instanceをここで再度実行するのは望ましくなさそう
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  }

  /// 指定した [SignInMethod] に関連する [UserSocialLogin] のプロパティを、引数で受けた真偽値に更新する
  Future<void> _updateUserSocialLoginSignInMethodStatus({
    required SignInMethod signInMethod,
    required String userId,
    required bool value,
  }) async {
    switch (signInMethod) {
      case SignInMethod.apple:
        await _userSocialLoginRepository.updateIsAppleEnabled(
          userId: userId,
          value: value,
        );
      case SignInMethod.google:
        await _userSocialLoginRepository.updateIsGoogleEnabled(
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
