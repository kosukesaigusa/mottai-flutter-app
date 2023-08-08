import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
}
