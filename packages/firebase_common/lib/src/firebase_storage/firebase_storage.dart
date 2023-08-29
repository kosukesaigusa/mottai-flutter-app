import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_storage_resource.dart';

/// Firebase Storageとのインタラクションを提供するサービスクラス。
class FirebaseStorageService {
  FirebaseStorageService() : _firebaseStorage = FirebaseStorage.instance;

  FirebaseStorageService.bucket(String bucket)
      : _firebaseStorage = FirebaseStorage.instanceFor(bucket: bucket);

  late final FirebaseStorage _firebaseStorage;

  /// リソースをFirebase Storageに指定された [path] にアップロードする。
  ///
  /// [resource] パラメータは [FirebaseStorageResource] のインスタンスである必要がある。
  Future<String> upload({
    required String path,
    required FirebaseStorageResource resource,
  }) async {
    final storageRef = _firebaseStorage.ref().child(path);
    switch (resource) {
      case FirebaseStorageFile():
        await storageRef.putFile(resource.file);
      case FirebaseStorageUrl():
        await storageRef.putString(resource.url);
      case FirebaseStorageRawData():
        await storageRef.putData(resource.data);
    }
    return storageRef.getDownloadURL();
  }

  /// 指定された [path] のリソースのダウンロードURLを取得する。
  Future<String> getDownloadURL({required String path}) async {
    final storageRef = _firebaseStorage.ref().child(path);
    return storageRef.getDownloadURL();
  }

  /// 指定された [path] のリソースを削除する。
  Future<void> delete({required String path}) async {
    final storageRef = _firebaseStorage.ref().child(path);
    return storageRef.delete();
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
    final storageRef = _firebaseStorage.ref().child(path);
    return storageRef.getData(megaByte);
  }

  /// 指定された [path] のすべての画像URLを取得する。
  Future<List<String>> fetchAllImageUrls({required String path}) async {
    final storageRef = _firebaseStorage.ref().child(path);
    final listResult = await storageRef.listAll();
    final futureImageUrls = listResult.items
        .map((reference) => reference.getDownloadURL())
        .toList();
    return Future.wait(futureImageUrls);
  }

  /// 指定された [path] の 画像URLのリスト と 次のページトークン を取得する。
  /// オプションで [maxResults] と [pageToken] の使用が可能。
  ///
  /// [maxResults] は、取得する結果の最大数を指定する。
  /// [pageToken] は、次のセットの結果を取得するためのページネーションに使用される。
  Future<(List<String>, String?)> fetchReferences({
    required String path,
    int maxResults = 100,
    String? pageToken,
  }) async {
    final storageRef = _firebaseStorage.ref().child(path);
    final listResult = await storageRef.list(
      ListOptions(
        maxResults: maxResults,
        pageToken: pageToken,
      ),
    );
    final futureImageUrls = listResult.items
        .map((reference) => reference.getDownloadURL())
        .toList();
    final imageUrls = await Future.wait(futureImageUrls);
    return (imageUrls, listResult.nextPageToken);
  }
}
