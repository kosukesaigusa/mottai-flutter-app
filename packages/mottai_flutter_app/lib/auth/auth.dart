import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../firestore_repository.dart';

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
/// [AuthService]でログインとログアウトされる度に値を更新する。
final authenticatorProvider = StateProvider<Authenticator>((ref) {
  return Authenticator.none;
});

final authServiceProvider =
    Provider.autoDispose<AuthService>(AuthService.new);

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService(ProviderRef ref): _ref = ref;

  static final _auth = FirebaseAuth.instance;
  final ProviderRef _ref;

  // TODO: 開発中のみ使用する。リリース時には消すか、あとで デバッグモード or
  // 開発環境接続時のみ使用可能にする。
  /// [FirebaseAuth] にメールアドレスとパスワードでサインインする。
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// Googleでのサインイン
  Future<UserCredential> signInWithGoogle({
    required GoogleSignInAuthentication googleAuth,
  }) async {
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _signInWithOauth(credential);
    _ref.read(authenticatorProvider.notifier).state = Authenticator.google;

    return userCredential;
  }

  /// OAuthでサインイン
  Future<UserCredential> _signInWithOauth(OAuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential;
  }


  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
    if(_ref.read(authenticatorProvider) == Authenticator.google){
      await GoogleSignIn().signOut();
    }
  }
}
