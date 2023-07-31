import 'dart:io';
import 'dart:typed_data';

sealed class FirebaseStorageResource {}

class FirebaseStorageFile extends FirebaseStorageResource {
  FirebaseStorageFile(this.file);
  final File file;
}

class FirebaseStorageUrl extends FirebaseStorageResource {
  FirebaseStorageUrl(this.url);
  final String url;
}

class FirebaseStorageRawData extends FirebaseStorageResource {
  FirebaseStorageRawData(this.data);
  final Uint8List data;
}
