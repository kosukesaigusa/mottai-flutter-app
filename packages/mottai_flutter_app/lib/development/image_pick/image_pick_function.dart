// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum PickType {
  camera,
  gallery,
}

final ImagePicker _picker = ImagePicker();

///一枚のみ選択する場合
///写真を撮影するか選択するかはenumのPickTypeで渡す
Future<File?> fetchSingleImage(PickType pickType) async {
  try {
    final _imageFile = await _picker.pickImage(
      source: pickType == PickType.camera
          ? ImageSource.camera
          : ImageSource.gallery,
    );
    return _imageFile == null ? null : File(_imageFile.path);
  } catch (e) {
    return null;
  }
}

///複数選択する場合
Future<List<File>> fetchMultipleImage() async {
  try {
    final _imageFiles = await _picker.pickMultiImage();
    return _imageFiles.map((e) => File(e.path)).toList();
  } catch (e) {
    return [];
  }
}
