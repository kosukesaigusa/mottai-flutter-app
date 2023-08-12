import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../../exception.dart';
import '../../user/host.dart';
import '../../user/user_mode.dart';
import '../auth.dart';

final authControllerProvider = Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    hostService: ref.watch(hostServiceProvider),
    userModeStateController: ref.watch(userModeStateProvider.notifier),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required HostService hostService,
    required StateController<UserMode> userModeStateController,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _authService = authService,
        _hostService = hostService,
        _userModeStateController = userModeStateController,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final AuthService _authService;

  final HostService _hostService;

  final StateController<UserMode> _userModeStateController;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 選択した [SignInMethod] でサインインする。
  /// サインイン後、必要性を確認して [UserMode] を `UserMode.Host` にする。
  Future<void> signIn(SignInMethod signInMethod) async {
    try {
      final userCredential = await _signIn(signInMethod);
      await _maybeSetUserModeToHost(userCredential);
    } on AppException catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }

  /// メールアドレスとパスワードでサインする。
  /// サインイン後、必要性を確認して [UserMode] を `UserMode.Host` にする。
  /// デバッグ目的でのみ使用する。
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _maybeSetUserModeToHost(userCredential);
    } on AppException catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }

  /// 選択した [SignInMethod] でサインインする。サインインが済んだユーザーの
  /// [UserCredential] を返す。
  /// 各種の例外が発生した場合には適切なメッセージを入れて [AppException] を
  /// スローする。呼び元でエラーハンドリングし、スナックバーを表示することを
  /// 期待する。
  Future<UserCredential> _signIn(SignInMethod signInMethod) async {
    switch (signInMethod) {
      case SignInMethod.google:
        try {
          return _authService.signInWithGoogle();
        }
        // NOTE: この例外は、ユーザーがログインをキャンセルした場合に発生する。
        on PlatformException catch (e) {
          if (e.code == 'network_error') {
            throw const AppException(
              message: '接続できませんでした。\nネットワーク状況を確認してください。',
            );
          }
          throw const AppException(message: 'キャンセルしました。');
        }
      case SignInMethod.apple:
        // NOTE: Apple はキャンセルやネットワークエラーの判定ができないので、try-catchしない。
        return _authService.signInWithApple();
      case SignInMethod.line:
        return _authService.signInWithLINE();
      case SignInMethod.email:
        throw UnimplementedError();
    }
  }

  /// サインインで得られた [UserCredential] を与え、それに対応する
  /// ホストドキュメントが存在するか確認し、存在する場合は [UserMode] を
  /// `UserMode.host` にする。
  Future<void> _maybeSetUserModeToHost(UserCredential userCredential) async {
    final uid = userCredential.user?.uid;
    if (uid == null) {
      return;
    }
    if (await _hostService.hostExists(hostId: uid)) {
      _userModeStateController.update((state) => UserMode.host);
    }
  }

  /// [FirebaseAuth] からサインアウトして、[UserMode] を `UserMode.worker` にする。
  Future<void> signOut() async {
    await _authService.signOut();
    _userModeStateController.update((state) => UserMode.worker);
  }
}
