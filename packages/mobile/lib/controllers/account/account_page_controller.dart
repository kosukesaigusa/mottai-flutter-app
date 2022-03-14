import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/repository/auth/auth_repository.dart';

import '../../theme/theme.dart';
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
      final result = await _reader(authRepository).signInWithGoogle();
      if (result == null) {
        _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
        return;
      }
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
      final result = await _reader(authRepository).signInWithApple();
      if (result == null) {
        _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
        return;
      }
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
  }

  /// LINE でサインインする。
  /// LINE におけるサインインではメールアドレスの取得をするのに同意が必要なので
  /// AlertDialog を表示する。
  Future<void> signInWithLINE() async {
    try {
      final agreed = await showDialog<bool>(
        context: _reader(scaffoldMessengerController).scaffoldMessengerKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                FaIcon(FontAwesomeIcons.line, color: Color(0xff00ba52)),
                Gap(8),
                Text('LINE ログインについて', style: bold12),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'このアプリでは、ログイン時の確認画面で許可を頂いた場合のみ、'
                  'あなたの LINE アカウントに登録されているメールアドレスを取得します。'
                  '取得したメールアドレスは、ユーザー管理および、他のソーシャルログインと'
                  '連携する目的以外では使用しません。'
                  'また、法令に定められた場合を除き、第三者へ提供することはありません。',
                  style: grey12,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop<bool>(context, true),
                child: const Text('同意して進む'),
              ),
            ],
          );
        },
      );
      if (!(agreed ?? false)) {
        return;
      }
      final result = await _reader(authRepository).signInWithLINE();
      if (result == null) {
        _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
        return;
      }
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
