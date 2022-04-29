import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

/// Dynamic Links などのパス文字列の先頭・末尾にスラッシュを付ける
String normalizePathString(String path) {
  var p = path;
  if (!p.startsWith('/')) {
    p = '/$p';
  }
  if (!p.endsWith('/')) {
    p = '$p/';
  }
  return p;
}
