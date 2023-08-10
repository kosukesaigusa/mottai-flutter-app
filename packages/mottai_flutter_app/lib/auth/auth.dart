import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../firestore_repository.dart';
import '../user/worker.dart';
import '../user_social_login/user_social_login.dart';

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
    userSocialLoginService: ref.watch(userSocialLoginServiceProvider),
  ),
);

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService({
    required WorkerService workerService,
    required UserSocialLoginService userSocialLoginService,
  })  : _workerService = workerService,
        _userSocialLoginService = userSocialLoginService;

  static final _auth = FirebaseAuth.instance;

  final WorkerService _workerService;
  final UserSocialLoginService _userSocialLoginService;

  // TODO: 開発中のみ使用する。リリース時には消すか、あとで デバッグモード or
  // 開発環境接続時のみ使用可能にする。
  /// [FirebaseAuth] にメールアドレスとパスワードでサインインする。
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// [FirebaseAuth] に Google でサインインする。
  /// https://firebase.flutter.dev/docs/auth/social/#google に従っている。
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn(); // サインインダイアログの表示
    final googleAuth = await googleUser?.authentication; // アカウントからトークン生成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _createWorkerAndUserSocialLoginWhenFirstSignIn(
      userCredential: userCredential,
      signInMethod: SignInMethod.google,
    );
    return userCredential;
  }

  /// [FirebaseAuth] に Apple でサインインする。
  /// https://firebase.flutter.dev/docs/auth/social/#apple に従っている。
  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

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
    final loginResult = await LineSDK.instance.login();
    final accessToken = loginResult.accessToken.data['access_token'] as String;
    final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
        .httpsCallable('createfirebaseauthcustomtoken');
    final response = await callable.call<Map<String, dynamic>>(
      <String, dynamic>{'accessToken': accessToken},
    );
    final customToken = response.data['customToken'] as String;
    final userCredential =
        await FirebaseAuth.instance.signInWithCustomToken(customToken);
    return userCredential;
  }

  /// 文字列から SHA-256 ハッシュを作成する。
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Google や Apple により初めてログインする場合（=まだ `Worker` が作成されていない場合）、
  /// Firebase の [UserCredential] をもとに
  /// `Worker` ドキュメントと `UserSocialLogin` ドキュメントを生成する。
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
    await _userSocialLoginService.createUserSocialLogin(
      userId: user.uid,
      signInMethod: signInMethod,
    );
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

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
        throw UnimplementedError();
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
      SignInMethod.email => throw UnimplementedError(),
    };
    //TODO FirebaseAuth.instanceをここで再度実行するのは望ましくなさそう？
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
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
      //TODO emailはなくなる想定
      case SignInMethod.email:
        throw UnimplementedError();
    }
  }

}
