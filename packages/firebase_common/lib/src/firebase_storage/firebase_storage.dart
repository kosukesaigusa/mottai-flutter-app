import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService({String? bucket}) {
    if (bucket != null) {
      _firebaseStorage = FirebaseStorage.instanceFor(bucket: bucket);
    } else {
      _firebaseStorage = FirebaseStorage.instance;
    }
  }
  late FirebaseStorage _firebaseStorage;

  Future<String> upload({required String path, required File file}) async {
    final imageRef = _firebaseStorage.ref().child(path);
    await imageRef.putFile(file);
    return imageRef.getDownloadURL();
  }
}
