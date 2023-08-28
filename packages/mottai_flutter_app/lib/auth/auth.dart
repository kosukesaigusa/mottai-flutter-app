import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../exception.dart';
import '../firestore_repository.dart';
import '../user/user_mode.dart';
import '../user/worker.dart';

/// Firebase Console の Authentication で設定できるサインイン方法の種別。
enum SignInMethod {
  google,
  apple,
  line,
  // TODO: 後で削除する予定
  email,
  ;
}

/// [FirebaseAuth] のインスタンスを提供する [Provider].
final _authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

/// [FirebaseAuth] の [User] を返す [StreamProvider].
/// ユーザーの認証状態が変更される（ログイン、ログアウトする）たびに更新される。
final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(_authProvider).userChanges(),
);

/// 現在のユーザー ID を提供する [Provider].
/// [authUserProvider] の変更を watch しているので、ユーザーの認証状態が変更され
/// るたびに、この [Provider] も更新される。
final userIdProvider = Provider<String?>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(_authProvider).currentUser?.uid;
});

/// ユーザーがログインしているかどうかを示す bool 値を提供する Provider.
/// [userIdProvider] の変更を watch しているので、ユーザーの認証状態が変更される
/// たびに、この [Provider] も更新される。
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(userIdProvider) != null,
);

/// 指定した [UserSocialLogin] ドキュメントを購読する [StreamProvider].
final userSocialLoginStreamProvider =
    StreamProvider.family.autoDispose<ReadUserSocialLogin?, String>(
  (ref, userId) => ref
      .watch(userSocialLoginRepositoryProvider)
      .subscribeUserSocialLogin(userId: userId),
);

final authServiceProvider = Provider.autoDispose<AuthService>(
  (ref) => AuthService(
    workerService: ref.watch(workerServiceProvider),
    userSocialLoginRepository: ref.watch(userSocialLoginRepositoryProvider),
    userModeStateController: ref.watch(userModeStateProvider.notifier),
  ),
);

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService({
    required WorkerService workerService,
    required UserSocialLoginRepository userSocialLoginRepository,
    required StateController<UserMode> userModeStateController,
  })  : _workerService = workerService,
        _userSocialLoginRepository = userSocialLoginRepository,
        _userModeStateController = userModeStateController;

  static final _auth = FirebaseAuth.instance;

  final WorkerService _workerService;
  final UserSocialLoginRepository _userSocialLoginRepository;
  final StateController<UserMode> _userModeStateController;

  // TODO: 開発中のみ使用する。リリース時には消すか、あとで デバッグモード or
  // 開発環境接続時のみ使用可能にする。
  /// [FirebaseAuth] にメールアドレスとパスワードでサインインする。
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// [FirebaseAuth] に Google でサインインする。
  ///
  /// https://firebase.flutter.dev/docs/auth/social/#google に従っているが、
  /// [AuthCredential] を取得するまでの処理は、
  /// [_linkWithCredential] でも使用するため、別メソッドして定義している
  Future<UserCredential> signInWithGoogle() async {
    final credential = await _getGoogleAuthCredential();

    final userCredential = await _auth.signInWithCredential(credential);
    await _createWorkerAndUserSocialLoginWhenFirstSignIn(
      userCredential: userCredential,
      signInMethod: SignInMethod.google,
    );
    return userCredential;
  }

  /// [FirebaseAuth] に Apple でサインインする。
  ///
  /// https://firebase.flutter.dev/docs/auth/social/#apple に従っているが、
  /// [AuthCredential] を取得するまでの処理は、
  /// [_linkWithCredential] でも使用するため、別メソッドして定義している
  Future<UserCredential> signInWithApple() async {
    final oauthCredential = await _getAppleAuthCredential();

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    await _createWorkerAndUserSocialLoginWhenFirstSignIn(
      userCredential: userCredential,
      signInMethod: SignInMethod.apple,
    );
    return userCredential;
  }

  /// [FirebaseAuth] に LINE でサインインする。
  /// https://firebase.flutter.dev/docs/auth/custom-auth に従っている。
  Future<UserCredential> signInWithLINE() async {
    final userCredential = await _getLINEUserCredentialWithSignIn();
    await _createWorkerAndUserSocialLoginWhenFirstSignIn(
      userCredential: userCredential,
      signInMethod: SignInMethod.line,
    );
    return userCredential;
  }

  /// 文字列から SHA-256 ハッシュを作成する。
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Google / Apple / LINE により初めてログインする場合（=まだ [Worker] が作成されていない場合）、
  /// Firebase の [UserCredential] をもとに
  /// [Worker] ドキュメントと [UserSocialLogin] ドキュメントを生成する。
  Future<void> _createWorkerAndUserSocialLoginWhenFirstSignIn({
    required UserCredential userCredential,
    required SignInMethod signInMethod,
  }) async {
    final user = userCredential.user;
    if (user == null) {
      return;
    }
    final workerExists = await _workerService.workerExists(workerId: user.uid);
    if (workerExists) {
      return;
    }
    await _workerService.createWorker(
      workerId: user.uid,
      displayName: user.displayName ?? '',
    );
    await _createUserSocialLogin(
      userId: user.uid,
      signInMethod: signInMethod,
    );
  }

  /// [FirebaseAuth] からサインアウトする。
  /// [GoogleSignIn] からもサインアウトする。
  /// また、[UserMode] を `UserMode.worker` に戻す。
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    _userModeStateController.update((state) => UserMode.worker);
  }

  /// [UserSocialLogin] の作成
  ///
  /// 指定した [SignInMethod] に関連するプロパティのみを `true` とした [UserSocialLogin] を作成する
  Future<void> _createUserSocialLogin({
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
        throw UnimplementedError();
    }
  }

  /// 指定されたソーシャル認証情報をアカウントにリンクする
  ///
  /// 指定された [SignInMethod] のソーシャル認証情報をアカウントにリンクし、
  /// 指定された [SignInMethod] に関連する [UserSocialLogin] のプロパティを `true` に更新する
  Future<void> linkUserSocialLogin({
    required SignInMethod signInMethod,
    required String userId,
  }) async {
    await _linkWithCredential(signInMethod: signInMethod);
    await _updateUserSocialLoginSignInMethodStatus(
      signInMethod: signInMethod,
      userId: userId,
      value: true,
    );
  }

  /// 指定されたソーシャル認証情報のリンクを解除する
  ///
  /// 指定された [SignInMethod] のソーシャル認証情報のリンクを解除し、
  /// 指定された [SignInMethod] に関連する [UserSocialLogin] のプロパティを `false` に更新する
  Future<void> unLinkUserSocialLogin({
    required SignInMethod signInMethod,
    required String userId,
  }) async {
    await _unlinkWithProviderId(signInMethod: signInMethod);
    await _updateUserSocialLoginSignInMethodStatus(
      signInMethod: signInMethod,
      userId: userId,
      value: false,
    );
  }

  /// ログイン時に取得される [AuthCredential] を元に、ユーザーアカウントにソーシャル認証情報をリンクする
  Future<void> _linkWithCredential({required SignInMethod signInMethod}) async {
    final credential = switch (signInMethod) {
      SignInMethod.google => await _getGoogleAuthCredential(),
      SignInMethod.apple => await _getAppleAuthCredential(),
      SignInMethod.line => await _getLINEAuthCredential(),
      //TODO emailは追って削除される想定
      SignInMethod.email => throw UnimplementedError(),
    };
    await _auth.currentUser?.linkWithCredential(credential);
  }

  /// 指定された [SignInMethod] に関連する [UserSocialLogin] のプロパティを、引数で受けた真偽値に更新する
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
      //TODO emailはなくなる想定
      case SignInMethod.email:
        throw UnimplementedError();
    }
  }

  /// Google認証から [AuthCredential] を取得する
  ///
  /// [GoogleSignIn] ライブラリを使用してユーザーにGoogleでのログインを求め、
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す
  Future<AuthCredential> _getGoogleAuthCredential() async {
    try {
      final googleUser = await GoogleSignIn().signIn(); // サインインダイアログの表示

      // サインインダイアログでキャンセルが選択された場合には、AppException をスローし、キャンセルされたことを通知する
      if (googleUser == null) {
        throw const AppException(message: 'キャンセルされました');
      }

      final googleAuth = await googleUser.authentication; // アカウントからトークン生成

      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        throw const AppException(message: '接続できませんでした。\nネットワーク状況を確認してください。');
      }
      throw const AppException(message: 'Google認証に失敗しました');
    }
  }

  /// Apple認証から [AuthCredential] を取得する
  ///
  /// Appleでのログインを求め、
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す。
  Future<AuthCredential> _getAppleAuthCredential() async {
    try {
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
    } on SignInWithAppleAuthorizationException catch (e) {
      // サインインダイアログでキャンセルが選択された場合には、AppException をスローし、キャンセルされたことを通知する
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AppException(message: 'キャンセルされました');
      }
      throw const AppException(message: 'Apple認証に失敗しました');
    }
  }

  /// LINEでのログインを求め、 [UserCredential] を取得する
  Future<UserCredential> _getLINEUserCredentialWithSignIn() async {
    try {
      final loginResult = await LineSDK.instance.login();
      final accessToken =
          loginResult.accessToken.data['access_token'] as String;
      final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
          .httpsCallable('createfirebaseauthcustomtoken');
      final response = await callable.call<Map<String, dynamic>>(
        <String, dynamic>{'accessToken': accessToken},
      );
      final customToken = response.data['customToken'] as String;
      return FirebaseAuth.instance.signInWithCustomToken(customToken);
    } on PlatformException catch (e) {
      // サインインダイアログでユーザーによりキャンセルが選択された場合には、AppException をスローし、キャンセルされたことを通知する
      if (e.message == 'User cancelled or interrupted the login process.') {
        throw const AppException(message: 'キャンセルされました');
      }
      rethrow;
    }
  }

  /// LINE認証から [AuthCredential] を取得する
  ///
  /// LINEでのログインを求め、
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す。
  /// カスタム認証の場合、[AuthCredential] は、一度ユーザーアカウントを作成してからではないと取得できないようなので、
  /// 一時的なユーザーアカウントを作成し、[AuthCredential] 取得後に、その一時的なアカウントを削除するという手順を踏んでいる
  Future<AuthCredential> _getLINEAuthCredential() async {
    // AuthCredential を取得するために、LINEログインにより一時的なユーザーアカウントを作成する
    final tempUserCredential = await _getLINEUserCredentialWithSignIn();

    final tempUser = tempUserCredential.user;

    // 一時的に作成したユーザーアカウントから AuthCredential を取得
    final authCredential = tempUserCredential.credential;

    // 何かしらの理由により、一時的に作成したアカウントの credential or user が null だった場合は、
    // AppException をスローし、認証連携が失敗したことを通知する
    if (authCredential == null || tempUser == null) {
      throw const AppException(message: 'LINEによる認証連携ができませんでした。');
    }

    // 一時的に作成したユーザーアカウントを削除
    await tempUser.delete();

    return authCredential;
  }

  /// ログインユーザーが持つ `providerId` を元に、指定された [SignInMethod] のリンクを解除する
  Future<void> _unlinkWithProviderId({
    required SignInMethod signInMethod,
  }) async {
    const googleProviderId = 'google.com';
    const appleProviderId = 'apple.com';
    const customProviderId = 'custom';

    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final providerIdToUnlink = switch (signInMethod) {
      SignInMethod.google => googleProviderId,
      SignInMethod.apple => appleProviderId,
      SignInMethod.line => customProviderId,
      //TODO emailは削除される想定
      SignInMethod.email => throw UnimplementedError(),
    };

    for (final userInfo in user.providerData) {
      if (userInfo.providerId == providerIdToUnlink) {
        await user.unlink(providerIdToUnlink);
        return;
      }
    }
  }

  /// 引数で受ける [userSocialLogin] を元に、複数の認証方法が有効化されているかを判定し、真偽値を返す
  bool hasMultipleAuthMethodsEnabled(
    ReadUserSocialLogin userSocialLogin,
  ) {
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
}
