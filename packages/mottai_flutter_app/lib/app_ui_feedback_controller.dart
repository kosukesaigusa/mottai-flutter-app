import 'package:dart_flutter_common/dart_flutter_common.dart' as common;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scaffoldMessengerKeyProvider =
    Provider((_) => GlobalKey<ScaffoldMessengerState>());

final navigatorKeyProvider = Provider((_) => GlobalKey<NavigatorState>());

final appUIFeedbackControllerProvider = Provider.autoDispose(
  (ref) => AppUIFeedbackController(
    scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
    navigatorKey: ref.watch(navigatorKeyProvider),
  ),
);

/// ツリー上部の [ScaffoldMessenger] 上でスナックバーやダイアログの表示を操作する。
/// `MainApp` に設置した `scaffoldMessengerKey`, `navigatorKey` を使ってスナックバーや
/// ダイアログの表示を操作する。
/// dart_flutter_common の [common.UIFeedbackController] を継承して当該パッケージ用に
/// 機能を追加している。
class AppUIFeedbackController extends common.UIFeedbackController {
  AppUIFeedbackController({
    required super.scaffoldMessengerKey,
    required super.navigatorKey,
  });

  /// [FirebaseException] 起点で [SnackBar] を表示する。
  ScaffoldFeatureController<SnackBar,
      SnackBarClosedReason> showSnackBarByFirebaseException(
    FirebaseException e,
  ) =>
      showSnackBar('[${e.code}]: ${e.message ?? 'FirebaseException が発生しました。'}');

  /// [FirebaseAuthException] 起点で [SnackBar] を表示する。
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackBarByFirebaseAuthException(
    FirebaseAuthException e,
  ) {
    final code = e.code;
    switch (code) {
      case 'invalid-email':
        return showSnackBar('メールアドレスの形式が正しくありません。');
      case 'user-not-found':
        return showSnackBar('ユーザーが見つかりませんでした。');
      case 'wrong-password':
        return showSnackBar('パスワードが間違っています。');
      case 'user-disabled':
        return showSnackBar('ユーザーが無効化されています。');
      case 'too-many-requests':
        return showSnackBar('リクエストが多すぎます。しばらく時間をおいてから再度お試しください。');
      case 'operation-not-allowed':
        return showSnackBar('この操作は許可されていません。');
      case 'email-already-in-use':
        return showSnackBar('このメールアドレスは既に使用されています。');
      case 'weak-password':
        return showSnackBar('パスワードが弱すぎます。');
      default:
        return showSnackBar('FirebaseAuthException が発生しました。');
    }
  }
}
