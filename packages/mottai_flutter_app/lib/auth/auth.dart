import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

final authServiceProvider = Provider.autoDispose<AuthService>(
  (ref) => AuthService(
    workerService: ref.watch(workerServiceProvider),
  ),
);

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService({
    required WorkerService workerService,
  }) : _workerService = workerService;

  static final _auth = FirebaseAuth.instance;

  final WorkerService _workerService;

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
    await _maybeCreateWorkerByUserCredential(userCredential: userCredential);
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
    await _maybeCreateWorkerByUserCredential(userCredential: userCredential);
    return userCredential;
  }

  /// 文字列から SHA-256 ハッシュを作成する。
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// サインイン時に、まだ Worker ドキュメントが存在していなければ、Firebase
  /// の [UserCredential] をもとに生成する。
  /// Google や Apple によるはじめてのログインのときに相当する。
  Future<void> _maybeCreateWorkerByUserCredential({
    required UserCredential userCredential,
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
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
