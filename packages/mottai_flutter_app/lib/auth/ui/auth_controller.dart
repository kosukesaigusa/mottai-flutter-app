import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../auth.dart';

final authControllerProvider = Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _authService = authService,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final AuthService _authService;
  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 選択した [SignInMethod] でサインインする。
  Future<void> signIn(SignInMethod authenticator) async {
    switch (authenticator) {
      case SignInMethod.google:
        try {
          await _authService.signInWithGoogle();
        }
        // キャンセル時
        on PlatformException catch (e) {
          if (e.code == 'network_error') {
            _appScaffoldMessengerController
                .showSnackBar('接続できませんでした。\nネットワーク状況を確認してください。');
          }
          _appScaffoldMessengerController.showSnackBar('キャンセルしました。');
        }

      case SignInMethod.apple:
        // Apple はキャンセルやネットワークエラーの判定ができないので、try-catchしない
        await _authService.signInWithApple();
      case SignInMethod.line:
      case SignInMethod.email:
        throw UnimplementedError();
    }
    return;
  }
}
