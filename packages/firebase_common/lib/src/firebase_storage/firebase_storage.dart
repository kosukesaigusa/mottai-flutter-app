import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final Reference _reference = FirebaseStorage.instance.ref();

  Future<String> upload({required String path, required File file}) async {
    final imageRef = _reference.child(path);
    await imageRef.putFile(file);
    return imageRef.getDownloadURL();
  }
}
