import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../user_social_login.dart';

final userSocialLoginControllerProvider =
    Provider.autoDispose<UserSocialLoginController>(
  (ref) => UserSocialLoginController(
    userSocialLoginService: ref.watch(userSocialLoginServiceProvider),
  ),
);

class UserSocialLoginController {
  const UserSocialLoginController({
    required UserSocialLoginService userSocialLoginService,
  }) : _userSocialLoginService = userSocialLoginService;

  final UserSocialLoginService _userSocialLoginService;

  Future<void> linkUserSocialLogin({
    required SignInMethod signInMethod,
    required String userId,
    required bool value,
  }) async {
    try {
      await _userSocialLoginService.linkUserSocialLogin(
        signInMethod: signInMethod,
        userId: userId,
        value: value,
      );
    } on FirebaseAuthException catch(e) {
      //TODO 
    }
  }
}
