import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const defaultSnackBarBehavior = SnackBarBehavior.floating;
const defaultSnackBarDuration = Duration(seconds: 3);

///
class ScaffoldMessengerController {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// スナックバーを表示する
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    String message, {
    bool removeCurrentSnackBar = true,
    Duration duration = defaultSnackBarDuration,
  }) {
    if (removeCurrentSnackBar) {
      scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    }
    return scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      behavior: defaultSnackBarBehavior,
      duration: duration,
    ));
  }

  /// Firebase 関係の例外発生時に表示するスナックバー
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showByFirebaseException(
      FirebaseException e) {
    return show('[${e.code}]: ${e.message ?? 'FirebaseException が発生しました。'}');
  }

  /// 何らかの例外発生時に表示するスナックバー
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showByException(Exception e) {
    return show('[${e.toString()}]: エラーが発生しました。');
  }

  void remove() {
    scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
  }
}
