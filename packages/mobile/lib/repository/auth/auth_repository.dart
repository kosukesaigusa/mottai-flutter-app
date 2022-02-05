import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/constants/string.dart';
import 'package:mottai_flutter_app/controllers/firebase/firebase_task_result.dart';

final authRepository = Provider.autoDispose((ref) => AuthRepository());

class AuthRepository {
  AuthRepository();

  final auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

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
  Future<FirebaseTaskResult<UserCredential>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseTaskResult<UserCredential>.success(
        contents: userCredential,
        message: 'サインインしました。',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: 'そのアカウントはご使用になれません。',
          code: e.code,
        );
      } else if (e.code == 'user-not-found') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: '入力されたメールアドレスのユーザーは見つかりません。',
          code: e.code,
        );
      } else if (e.code == 'wrong-password') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: 'パスワードが正しくありません。',
          code: e.code,
        );
      } else if (e.code == 'too-many-requests') {
        return FirebaseTaskResult<UserCredential>.failure(
          message: '認証失敗の回数が一定を超えました。'
              'しばらくして再度サインインしてください。',
          code: e.code,
        );
      } else {
        return FirebaseTaskResult<UserCredential>.failure(
          message: generalErrorMessage,
          code: e.code,
        );
      }
    }
  }

  /// Google サインイン
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return _googleSignIn.signIn();
    } on PlatformException {
      rethrow;
    }
  }

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
