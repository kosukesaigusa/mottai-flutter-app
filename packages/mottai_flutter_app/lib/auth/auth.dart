import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../user/user.dart';
import '../user/worker.dart';

enum Authenticator {
  none,
  google,
  apple,
  email,
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
/// [userIdProvider] の変更を watch しているので、ユーザーの認証状態が変更され
/// るたびに、この [Provider] も更新される。
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(userIdProvider) != null,
);

/// 現在の認証方法を提供する[Provider]
/// [authUserProvider] の変更を watch しているので、ユーザーの認証状態が変更され
/// るたびに、この [Provider] も更新される。
/// 認証者のURLが[User].[UserInfo.providerId]に入っている。
/// そのため、以下のような条件で判定を行う。
/// [UserInfo.providerId] : 'google.com' => google認証
/// [UserInfo.providerId] : 'apple.com' => apple認証
final authenticatorProvider = Provider<Authenticator>((ref) {
  ref.watch(authUserProvider);
  final user = ref.watch(_authProvider).currentUser;

  // リンクされるごとにproviderDataが追加されるが、同時に1アカウントしか認証しないため
  // 最初のデータのみを見る。
  final infos = user?.providerData;
  if (!(infos?.isEmpty ?? true)) {
    final providerId = infos!.first.providerId;
    if (providerId == 'google.com') {
      return Authenticator.google;
    } else if (providerId == 'apple.com') {
      return Authenticator.apple;
    }
  }
  return Authenticator.none;
});
final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  return AuthService(
    ref.watch(workerServiceProvider),
    ref.watch(workerDocumentExistsProvider),
    ref.watch(authenticatorProvider),
  );
});

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService(
    WorkerService workerService,
    Future<bool> Function() isWorkerExist,
    Authenticator authenticator,
  )   : _workerService = workerService,
        _isWorkerExist = isWorkerExist,
        _authenticator = authenticator;

  static final _auth = FirebaseAuth.instance;
  final WorkerService _workerService;
  final Future<bool> Function() _isWorkerExist;
  final Authenticator _authenticator;

  // TODO: 開発中のみ使用する。リリース時には消すか、あとで デバッグモード or
  // 開発環境接続時のみ使用可能にする。
  /// [FirebaseAuth] にメールアドレスとパスワードでサインインする。
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// Googleでのサインイン
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn(); // サインインダイアログの表示
    final googleAuth = await googleUser?.authentication; // アカウントからトークン生成
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _signIn(userCredential);
    return userCredential;
  }

  /// Nonceを作成する。
  /// Nonceは周期性のない[Random.secure]から生成する。
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// 文字列からSHA-256ハッシュを作成する。
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Appleでのサインイン
  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

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
    await _signIn(userCredential);
    return userCredential;
  }

  Future<void> _signIn(UserCredential user) async {
    // ユーザーが存在していない場合作成する。
    if (!(await _isWorkerExist())) {
      final signInUser = user.user;
      final uid = signInUser?.uid;
      if ((signInUser != null) && (uid != null)) {
        await _workerService.create(
            workerId: uid, displayName: user.user?.displayName ?? '');
      }
    }
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
    if (_authenticator == Authenticator.google) {
      await GoogleSignIn().signOut();
    }
  }
}
