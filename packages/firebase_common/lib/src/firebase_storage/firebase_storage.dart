import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_storage_resource.dart';

/// Firebase Storageとのインタラクションを提供するサービスクラス。
class FirebaseStorageService {
  /// カスタムの [bucket] を使用して、新しい [FirebaseStorageService] のインスタンスを作成する。
  ///
  /// [bucket] が指定された場合、そのバケットが使用される。
  /// そうでない場合、デフォルトのバケットが使用される。
  FirebaseStorageService({String? bucket}) {
    if (bucket != null) {
      _firebaseStorage = FirebaseStorage.instanceFor(bucket: bucket);
    } else {
      _firebaseStorage = FirebaseStorage.instance;
    }
  }
  late FirebaseStorage _firebaseStorage;

  /// リソースをFirebase Storageに指定された [path] にアップロードする。
  ///
  /// [resource] パラメータは [FirebaseStorageResource] のインスタンスである必要がある。
  Future<String> upload({
    required String path,
    required FirebaseStorageResource resource,
  }) async {
    final imageRef = _firebaseStorage.ref().child(path);
    switch (resource) {
      case FirebaseStorageFile():
        await imageRef.putFile(resource.file);
      case FirebaseStorageUrl():
        await imageRef.putString(resource.url);
      case FirebaseStorageRawData():
        await imageRef.putData(resource.data);
    }
    return imageRef.getDownloadURL();
  }

  /// 指定された [path] のリソースのダウンロードURLを取得する。
  Future<String> getDownloadURL({required String path}) async {
    final imageRef = _firebaseStorage.ref().child(path);
    return imageRef.getDownloadURL();
  }

  /// 指定された [path] のリソースを削除する。
  Future<void> delete({required String path}) async {
    final imageRef = _firebaseStorage.ref().child(path);
    return imageRef.delete();
  }

  /// 指定された [path] のリソースのバイトデータを取得する。
  ///
  /// オプションの [byte] パラメータは、取得するバイト数の最大値を指定する。
  /// デフォルトでは、1MB（1024 * 1024バイト）のデータが取得される。
  Future<Uint8List?> getData({
    required String path,
    int byte = 1024,
  }) async {
    final megaByte = byte * byte;
    final imageRef = _firebaseStorage.ref().child(path);
    return imageRef.getData(megaByte);
  }

  /// 指定された [path] のすべてのリファレンス（ファイルとディレクトリ）を取得する。
  Future<ListResult> fetchAllReferences({required String path}) async {
    final storageRef = _firebaseStorage.ref().child(path);
    return storageRef.listAll();
  }

  /// 指定された [path] のリファレンス（ファイルとディレクトリ）のリストを取得する。
  /// オプションで [maxResults] と [pageToken] の使用が可能。
  ///
  /// [maxResults] は、取得する結果の最大数を指定する。
  /// [pageToken] は、次のセットの結果を取得するためのページネーションに使用される。
  Future<ListResult> fetchList({
    required String path,
    int maxResults = 100,
    String? pageToken,
  }) async {
    final storageRef = _firebaseStorage.ref().child(path);
    return storageRef.list(
      ListOptions(
        maxResults: maxResults,
        pageToken: pageToken,
      ),
    );
  }
}
