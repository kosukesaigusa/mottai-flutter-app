import 'dart:io';

import 'package:image_picker/image_picker.dart';


enum PickType {
  camera,
  gallery,
}
final ImagePicker _picker = ImagePicker();

///一枚のみ選択する場合
///写真を撮影するか選択するかはenumのPickTypeで渡す
Future<File> fetchSingleImage(PickType pickType) async {
  final _imageFile = await _picker.pickImage(
    source:
        pickType == PickType.camera ? ImageSource.camera : ImageSource.gallery,
  );
  if (_imageFile == null) {
    throw Exception('画像が選択されませんでした。');
  }
  return File(_imageFile.path);
}

///複数選択する場合
Future<List<File>> fetchMultipleImage() async {
  final _imageFiles = await _picker.pickMultiImage();
  return _imageFiles.map((e) => File(e.path)).toList();
}
