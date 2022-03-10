import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/repository/auth/auth_repository.dart';

import '../scaffold_messenger/scaffold_messenger_controller.dart';
import 'account_page_state.dart';

final accountPageController = StateNotifierProvider<AccountPageController, AccountPageState>(
  (ref) => AccountPageController(ref.read),
);

class AccountPageController extends StateNotifier<AccountPageState> {
  AccountPageController(this._reader) : super(const AccountPageState());

  final Reader _reader;

  /// Google でサインインする。
  Future<void> signInWithGoogle() async {
    try {
      await _reader(authRepository).signInWithGoogle();
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    } on Exception {
      _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
    }
  }

  /// Apple でサインインする。
  Future<void> signInWithApple() async {
    try {
      await _reader(authRepository).signInWithApple();
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
  }

  /// LINE でサインインする。
  Future<void> signInWithLine() async {
    try {
      await _reader(authRepository).signInWithLine();
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
  }

  /// サインアウト
  Future<void> signOut() async {
    try {
      await _reader(authRepository).signOut();
    } on FirebaseAuthException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] サインアウトに失敗しました。');
    } on Exception {
      _reader(scaffoldMessengerController).showSnackBar('サインアウトに失敗しました。');
    }
  }
}
