import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    if (_imageFile == null) {
      throw Exception('画像が選択されませんでした');
    } else {
      return File(_imageFile.path);
    }
  } on PlatformException catch (e) {
    if (e.code == 'photo_access_denied') {
      await openAppSettings();
    }
    throw Exception(e.message); // PlatformExceptionのメッセージを保持したまま再スローする
  } on Exception catch (e) {
    throw Exception(e); // その他の例外はそのまま再スローする
  }
}

///複数選択する場合
Future<List<File>> fetchMultipleImage() async {
  try {
    final _imageFiles = await _picker.pickMultiImage();
    if (_imageFiles.isEmpty) {
      throw Exception('画像が選択されませんでした');
    } else {
      return _imageFiles.map((e) => File(e.path)).toList();
    }
  } on PlatformException catch (e) {
    if (e.code == 'photo_access_denied') {
      await openAppSettings();
    }
    throw Exception(e.message); // PlatformExceptionのメッセージを保持したまま再スローする
  } on Exception catch (e) {
    throw Exception(e); // その他の例外はそのまま再スローする
  }
}
