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
  /// 初めてサインインした場合に限り、
  /// 指定した [SignInMethod] に関連するプロパティのみを `true` とした [UserSocialLogin] を作成する
  Future<void> createUserSocialLoginWhenFirstSignIn({
    required String userId,
  }) async {
    //TODO auth.dartに定義されている `workerExists` を活用し、初めてサインインする場合のみ `UserSocialLogin` を作成する
    await _userSocialLoginRepository.setUserSocialLogin(userId: userId);
  }

  /// 指定した [SignInMethod] に関連する [UserSocialLogin] のプロパティを、引数で受けた真偽値に更新する
  Future<void> updateSignInMethodStatus({
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
