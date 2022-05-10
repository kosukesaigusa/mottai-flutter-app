import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/snack_bar.dart';
import '../constants/string.dart';
import '../utils/extensions/string.dart';

final scaffoldMessengerServiceProvider = Provider.autoDispose((ref) => ScaffoldMessengerService());

/// ScaffoldMessenger 上でスナックバーやダイアログを表示するためのコントローラ
class ScaffoldMessengerService {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  /// showDialog で指定したビルダー関数を返す。
  Future<void> showDialogByBuilder<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: scaffoldMessengerKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// スナックバーを表示する
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    bool removeCurrentSnackBar = true,
    Duration duration = defaultSnackBarDuration,
  }) {
    final scaffoldMessengerState = scaffoldMessengerKey.currentState!;
    if (removeCurrentSnackBar) {
      scaffoldMessengerState.removeCurrentSnackBar();
    }
    return scaffoldMessengerState.showSnackBar(SnackBar(
      content: Text(message),
      behavior: defaultSnackBarBehavior,
      duration: duration,
    ));
  }

  /// FirebaseException 起点でスナックバーを表示する
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarByFirebaseException(
      FirebaseException e) {
    return showSnackBar('[${e.code}]: ${e.message ?? 'FirebaseException が発生しました。'}');
  }

  /// Exception 起点でスナックバーを表示するｌ
  /// Dart の Exception 型の場合は toString() 冒頭を取り除いて差し支えのないメッセージに置換しておく。
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarByException(Exception e) {
    final message = e.toString().replaceAll('Exception: ', '').replaceAll('Exception', '');
    return showSnackBar(message.ifIsEmpty(generalExceptionMessage));
  }

  /// フォーカスを外す
  void unFocus() {
    FocusScope.of(scaffoldMessengerKey.currentContext!).unfocus();
  }
}
