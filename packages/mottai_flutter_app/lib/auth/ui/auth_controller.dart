import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../../exception.dart';
import '../../loading/ui/loading.dart';
import '../../user/host.dart';
import '../../user/user_mode.dart';
import '../../user_fcm_token/user_fcm_token.dart';
import '../auth.dart';

final authControllerProvider = Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    hostService: ref.watch(hostServiceProvider),
    fcmTokenService: ref.watch(fcmTokenServiceProvider),
    userModeStateController: ref.watch(userModeStateProvider.notifier),
    overlayLoadingStateController:
        ref.watch(overlayLoadingStateProvider.notifier),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required HostService hostService,
    required FcmTokenService fcmTokenService,
    required StateController<UserMode> userModeStateController,
    required StateController<bool> overlayLoadingStateController,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _authService = authService,
        _hostService = hostService,
        _fcmTokenService = fcmTokenService,
        _userModeStateController = userModeStateController,
        _overlayLoadingStateController = overlayLoadingStateController,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final AuthService _authService;

  final HostService _hostService;

  final FcmTokenService _fcmTokenService;

  final StateController<UserMode> _userModeStateController;

  final StateController<bool> _overlayLoadingStateController;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 選択した [SignInMethod] でサインインする。
  /// サインイン後、必要性を確認して [UserMode] を `UserMode.Host` にする。
  /// サインインに成功した際は、[UserFcmToken] を登録する。
  Future<void> signIn(SignInMethod signInMethod) async {
    _overlayLoadingStateController.update((state) => true);
    try {
      final userCredential = await _signIn(signInMethod);
      await _maybeSetUserModeToHost(userCredential);
      await _setFcmToken(userCredential);
      _appScaffoldMessengerController.showSnackBar('サインインしました');
    } on AppException catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        _appScaffoldMessengerController.showSnackBar('このアカウントは退会済みのため無効です。');
      } else {
        _appScaffoldMessengerController.showSnackBarByFirebaseException(e);
      }
    } finally {
      _overlayLoadingStateController.update((state) => false);
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
        return _authService.signInWithGoogle();
      case SignInMethod.apple:
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

  /// サインインで得られた [UserCredential] を与え、それに対応するユーザーの FCM トークンを
  /// 保存する。
  Future<void> _setFcmToken(UserCredential userCredential) async {
    final uid = userCredential.user?.uid;
    if (uid == null) {
      return;
    }
    await _fcmTokenService.setUserFcmToken(userId: uid);
  }

  /// [SignInMethod] に基づいて、[AuthService] に定義されたソーシャルログインのリンク処理を実行する。
  ///
  /// - `signInMethod` : リンクまたはリンク解除を行うソーシャルログインの方法。
  /// - `userId` : 操作対象のユーザーID。
  Future<void> linkUserSocialLogin({
    required SignInMethod signInMethod,
    required String userId,
  }) async {
    try {
      await _authService.linkUserSocialLogin(
        signInMethod: signInMethod,
        userId: userId,
      );
    } on FirebaseException catch (e) {
      _appScaffoldMessengerController.showSnackBarByFirebaseException(e);
    } on AppException catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }

  /// 複数の認証方法が有効化されている場合、指定された [SignInMethod] に基づいて、
  /// [AuthService] に定義されたソーシャルログインのリンク解除処理を実行する。
  /// そうではない場合(単一の認証方法のみが有効化されている場合)は、解除不可であることをユーザーに通知する。
  ///
  /// - [signInMethod] : リンクまたはリンク解除を行うソーシャルログインの方法。
  /// - [userId] : 操作対象のユーザーID。
  /// - [userSocialLogin] : ユーザーの [UserSocialLogin] ドキュメント
  Future<void> unLinkUserSocialLogin({
    required SignInMethod signInMethod,
    required String userId,
    required ReadUserSocialLogin userSocialLogin,
  }) async {
    if (!_authService.hasMultipleAuthMethodsEnabled(userSocialLogin)) {
      // 単一の認証方法のみが有効化されている場合、
      // 本メソッドを呼び出す際に指定している SignInMethod がその単一の認証方法となるため、
      // 解除不可であることを SnackBar で表示する。
      _appScaffoldMessengerController.showSnackBar('唯一の認証のため解除できません。');
      return;
    }
    try {
      await _authService.unLinkUserSocialLogin(
        signInMethod: signInMethod,
        userId: userId,
      );
    } on FirebaseException catch (e) {
      _appScaffoldMessengerController.showSnackBarByFirebaseException(e);
    }
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _authService.signOut();
}
