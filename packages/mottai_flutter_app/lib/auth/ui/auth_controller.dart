import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
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
    } 
    //TODO リンク処理の過程でログインをキャンセルした際のエラーハンドリングが適切にできていない。
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
    //TODO controller が firebase_common に依存することは問題か？
    required ReadUserSocialLogin userSocialLogin,
  }) async {
    if (!_hasMultipleAuthMethodsEnabled(userSocialLogin)) {
      // 単一の認証方法のみが有効化されている場合、
      // 本メソッドを呼び出す際に指定している SignInMethod がその単一の認証方法となるため、
      // 解除不可であることをダイアログ表示する。
      //TODO 解除できないことをダイアログ表示する
      throw UnimplementedError();
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

  /// 引数で受ける [userSocialLogin] を元に、複数の認証方法が有効化されているかを判定し、真偽値を返す
  bool _hasMultipleAuthMethodsEnabled(
    ReadUserSocialLogin userSocialLogin,
  ) {
    //TODO 以下の記述箇所はService層である auth.dart に変更すべきか？
    //TODO ただし、そうした場合、 auth.dart が firebase_common に依存するが問題ないか？
    final enabledList = <bool>[];
    for (final signInMethod in SignInMethod.values) {
      switch (signInMethod) {
        case SignInMethod.google:
          enabledList.add(userSocialLogin.isGoogleEnabled);
        case SignInMethod.apple:
          enabledList.add(userSocialLogin.isAppleEnabled);
        case SignInMethod.line:
          enabledList.add(userSocialLogin.isLINEEnabled);
        //TODO email認証は追って削除される想定
        case SignInMethod.email:
          enabledList.add(false);
      }
    }

    return enabledList.where((isEnabled) => isEnabled).length > 1;
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _authService.signOut();
}
