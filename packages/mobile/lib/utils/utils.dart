import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/constants/snack_bar.dart';
import 'package:uuid/uuid.dart';

/// FirebaseAuth のインスタンス
FirebaseAuth get auth => FirebaseAuth.instance;

/// FirebaseFirestore のインスタンス
FirebaseFirestore get db => FirebaseFirestore.instance;

/// FirebaseStorage のインスタンス
FirebaseStorage get storage => FirebaseStorage.instance;

/// UUID V4
String get uuid => const Uuid().v4();

/// サインイン済みかどうか
bool get isSignedIn => auth.currentUser != null;

/// 簡便のため Non-null の uid を返す。
/// サインイン済みの画面でしか使用してはいけないので注意する。
String get nonNullUid => auth.currentUser!.uid;

/// BuildContext を引数にして SnackBar を表示する
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showFloatingSnackBar(
  BuildContext context,
  dynamic message, {
  bool removeCurrentSnackBar = true,
  Duration duration = defaultSnackBarDuration,
}) {
  final scaffoldMessengerState = ScaffoldMessenger.of(context);
  if (removeCurrentSnackBar) {
    scaffoldMessengerState.removeCurrentSnackBar();
  }
  // message が String 型ならそのまま、その他なら String 型に変換しつつ
  // ユーザーに見せるべきでない文言は調整して SnackBar を表示する。ｓ
  if (message is String) {
    return scaffoldMessengerState.showSnackBar(SnackBar(
      content: Text(message),
      behavior: defaultSnackBarBehavior,
      duration: duration,
    ));
  } else {
    return scaffoldMessengerState.showSnackBar(SnackBar(
      content: Text('$message'.replaceAll('Exception:', '')),
      behavior: defaultSnackBarBehavior,
      duration: duration,
    ));
  }
}

/// BuildContext を引数にして 現在表示している SnackBar を消す
void removeCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
