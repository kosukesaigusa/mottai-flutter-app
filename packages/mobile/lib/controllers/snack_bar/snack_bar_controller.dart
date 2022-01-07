import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const devaultSnackBarBehavior = SnackBarBehavior.floating;
const defaultSnackBarDuration = Duration(seconds: 3);

class SnackBarController {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    String message, {
    bool removeCurrentSnackabar = true,
    Duration duration = defaultSnackBarDuration,
  }) {
    if (removeCurrentSnackabar) {
      scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    }
    return scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      behavior: devaultSnackBarBehavior,
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
