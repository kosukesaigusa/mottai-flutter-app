import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_storage_resource.dart';

class FirebaseStorageService {
  FirebaseStorageService({String? bucket}) {
    if (bucket != null) {
      _firebaseStorage = FirebaseStorage.instanceFor(bucket: bucket);
    } else {
      _firebaseStorage = FirebaseStorage.instance;
    }
  }
  late FirebaseStorage _firebaseStorage;

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

  Future<String> getDownloadURL({required String path}) async {
    final imageRef = _firebaseStorage.ref().child(path);
    return imageRef.getDownloadURL();
  }

  Future<void> delete({required String path}) async {
    final imageRef = _firebaseStorage.ref().child(path);
    return imageRef.delete();
  }
}
