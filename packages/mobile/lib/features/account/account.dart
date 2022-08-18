import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../services/auth_service.dart';
import '../../utils/enums.dart';
import '../../utils/exceptions/common.dart';
import '../../utils/extensions/build_context.dart';
import '../../utils/loading.dart';
import '../../utils/scaffold_messenger_service.dart';
import '../auth/auth.dart';

/// サインイン中のユーザーの account ドキュメントを購読する StreamProvider。
final accountProvider = StreamProvider.autoDispose<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.read(accountRepositoryProvider).subscribeAccount(accountId: userId);
});

/// サインイン中のユーザーがホストかどうかを取得する StreamProvider。
final isHostProvider = Provider.autoDispose<bool>((ref) {
  final account = ref.watch(accountProvider).value;
  return account?.isHost ?? false;
});

/// サインイン中のユーザーの DocumentReference<Account> を取得する Provider
/// 未サインインの場合は例外をスローする。
final accountRefProvider = Provider.autoDispose<DocumentReference<Account>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return ref.read(accountRepositoryProvider).accountRef(accountId: userId);
});

/// メールアドレスとパスワードでのサインインするメソッドを提供する Provider。
final signInWithEmailAndPasswordProvider = Provider.autoDispose<
    Future<void> Function({
  required String email,
  required String password,
})>(
  (ref) => ({
    required email,
    required password,
  }) async {
    ref.read(overlayLoadingProvider.notifier).update((s) => true);
    try {
      await ref.read(authService).signInWithEmailAndPassword(email: email, password: password);
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('[${e.code}] キャンセルしました。');
    } on FirebaseException catch (e) {
      ref.read(scaffoldMessengerServiceProvider).showSnackBarByFirebaseException(e);
    } on Exception {
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('サインインに失敗しました。');
    } finally {
      ref.read(overlayLoadingProvider.notifier).update((s) => false);
    }
  },
);

/// Google, Apple, or LINE でサインインするメソッドを提供する Provider。
final signInWithSocialAccountProvider =
    Provider.autoDispose<Future<void> Function(SocialSignInMethod socialSignInMethod)>(
  (ref) => (method) async {
    if (method == SocialSignInMethod.LINE) {
      final agreed = await ref.read(agreeWithLINEEmailHandlingProvider)();
      if (!agreed) {
        return;
      }
    }
    ref.read(overlayLoadingProvider.notifier).update((s) => true);
    try {
      await ref.read(authService).signInWithSocialAccount(method);
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      ref
          .read(scaffoldMessengerServiceProvider)
          .showSnackBar('[${e.code}] サインインに失敗しました。(${e.toString()})');
    } on FirebaseException catch (e) {
      ref.read(scaffoldMessengerServiceProvider).showSnackBarByFirebaseException(e);
    } on Exception {
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('サインインに失敗しました。');
    } finally {
      ref.read(overlayLoadingProvider.notifier).update((s) => false);
    }
  },
);

/// LINE のログインの前にメールアドレスの取り扱いに同意するかどうかを
/// 確認するためのダイアログを表示するメソッドを提供する Provider。
final agreeWithLINEEmailHandlingProvider = Provider.autoDispose<Future<bool> Function()>(
  (ref) => () async {
    final agreed = await showDialog<bool>(
      context: ref.read(scaffoldMessengerServiceProvider).scaffoldMessengerKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              const FaIcon(FontAwesomeIcons.line, color: Color(0xff00ba52)),
              const Gap(8),
              Text('LINE ログインについて', style: context.titleSmall),
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
                style: context.bodySmall,
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
    return agreed ?? false;
  },
);

/// サインアウトするメソッドを提供する Provider。
final signOutProvider = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    ref.read(overlayLoadingProvider.notifier).update((s) => true);
    try {
      await ref.read(authService).signOut();
    } on FirebaseAuthException catch (e) {
      ref.read(scaffoldMessengerServiceProvider).showSnackBarByException(e);
    } on Exception {
      ref.read(scaffoldMessengerServiceProvider).showSnackBar('サインアウトに失敗しました。');
    } finally {
      ref.read(overlayLoadingProvider.notifier).update((s) => false);
    }
  },
);
