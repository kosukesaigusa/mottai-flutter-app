import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService({required String path}) {
    _reference = FirebaseStorage.instance.ref().child(path);
  }
  late Reference _reference;

  Future<String> upload(File file) async {
    await _reference.putFile(file);
    return _reference.getDownloadURL();
  }
}
