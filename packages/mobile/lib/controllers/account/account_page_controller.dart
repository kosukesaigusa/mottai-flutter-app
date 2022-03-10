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

  /// Google でサインインして、SharedPreferences に画像や名前を保存する。
  Future<void> signInWithGoogle() async {
    try {
      await _reader(authRepository).signInWithGoogle();
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
  }

  /// Apple でサインインして、SharedPreferences に名前を保存する。
  Future<void> signInWithApple() async {
    try {
      await _reader(authRepository).signInWithApple();
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
