import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository();

  final auth = FirebaseAuth.instance;

  /// ログイン済みかつCustomClaims のアドミンユーザーかどうか
  Future<bool> get isAdminUser async {
    final user = auth.currentUser;
    if (user == null) {
      return false;
    }
    final idTokenResult = await user.getIdTokenResult(true);
    return (idTokenResult.claims?['isAdmin'] ?? false) as bool;
  }

  /// メールアドレスとパスワードによるサインイン
  // Future<FirebaseTaskResult<UserCredential>> signInWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return FirebaseTaskResult<UserCredential>.success(
  //       contents: userCredential,
  //       message: 'サインインしました。',
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-disabled') {
  //       return FirebaseTaskResult<UserCredential>.failure(
  //         message: 'そのアカウントはご使用になれません。',
  //         code: e.code,
  //       );
  //     } else if (e.code == 'user-not-found') {
  //       return FirebaseTaskResult<UserCredential>.failure(
  //         message: '入力されたメールアドレスのユーザーは見つかりません。',
  //         code: e.code,
  //       );
  //     } else if (e.code == 'wrong-password') {
  //       return FirebaseTaskResult<UserCredential>.failure(
  //         message: 'パスワードが正しくありません。',
  //         code: e.code,
  //       );
  //     } else if (e.code == 'too-many-requests') {
  //       return FirebaseTaskResult<UserCredential>.failure(
  //         message: '認証失敗の回数が一定を超えました。'
  //             'しばらくして再度サインインしてください。',
  //         code: e.code,
  //       );
  //     } else {
  //       return FirebaseTaskResult<UserCredential>.failure(
  //         message: generalErrorMessage,
  //         code: e.code,
  //       );
  //     }
  //   }
  // }

  /// サインアウト
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }
}
