import 'dart:io';

import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../image/firebase_storage.dart';
import '../../../image/image_picker.dart';
import '../../../scaffold_messenger_controller.dart';
import '../../../widgets/dialog/permission_handler_dialog.dart';
import '../firebase_storage.dart';

final firebaseStorageControllerProvider = Provider.autoDispose(
  (ref) => FirebaseStorageController(
    firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
    imagePickerService: ref.watch(imagePickerServiceProvider),
    imageUrlsController: ref.watch(imageUrlsStateProvider.notifier),
    uploadedImagePathController:
        ref.watch(uploadedImagePathStateProvider.notifier),
    uploadedImageUrlController:
        ref.watch(uploadedImageUrlStateProvider.notifier),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
    pickedImageFromGalleryController:
        ref.watch(pickedImageFileStateProvider.notifier),
  ),
);

class FirebaseStorageController {
  FirebaseStorageController({
    required FirebaseStorageService firebaseStorageService,
    required ImagePickerService imagePickerService,
    required StateController<File?> pickedImageFromGalleryController,
    required StateController<String> uploadedImagePathController,
    required StateController<String> uploadedImageUrlController,
    required StateController<List<String>> imageUrlsController,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _firebaseStorageService = firebaseStorageService,
        _imagePickerService = imagePickerService,
        _uploadedImagePathController = uploadedImagePathController,
        _uploadedImageUrlController = uploadedImageUrlController,
        _pickedImageFromGalleryController = pickedImageFromGalleryController,
        _imageUrlsController = imageUrlsController,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final FirebaseStorageService _firebaseStorageService;

  final ImagePickerService _imagePickerService;

  final StateController<String> _uploadedImageUrlController;

  final StateController<String> _uploadedImagePathController;

  final StateController<List<String>> _imageUrlsController;

  final StateController<File?> _pickedImageFromGalleryController;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 画像を 1 つ端末のギャラリーから選択する。
  Future<void> pickImageFromGallery() async {
    try {
      final path = await _imagePickerService.pickImage(ImageSource.gallery);
      if (path != null) {
        _pickedImageFromGalleryController.update((state) => File(path));
      }
    } on PlatformException catch (e) {
      if (e.code != 'photo_access_denied') {
        return;
      }
      await _appScaffoldMessengerController.showDialogByBuilder<bool>(
        builder: (context) => const AccessDeniedDialog.gallery(),
      );
    }
  }

  /// 画像を FirebaseStorage の指定した [path] にアップロードする。
  Future<void> uploadImage({
    required String path,
    required FirebaseStorageResource resource,
  }) async {
    try {
      final imagePath = '$path/${DateTime.now()}.jpg';
      final imageUrl = await _firebaseStorageService.upload(
        path: imagePath,
        resource: resource,
      );
      _uploadedImagePathController.update((_) => imagePath);
      _uploadedImageUrlController.update((_) => imageUrl);
    } on Exception catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }

  /// FirebaseStorage の 指定した [path] のファイルを削除する。
  Future<void> deleteImage(String path) async {
    try {
      await _firebaseStorageService.delete(path: path);
      _uploadedImagePathController.update((_) => '');
      _uploadedImageUrlController.update((_) => '');
    } on Exception catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }

  /// FirebaseStorage から 指定した [path] のimageUrl のリストを取得する。
  Future<void> fetchImageUrls(String path) async {
    try {
      final imageUrls =
          await _firebaseStorageService.fetchAllImageUrls(path: path);
      _imageUrlsController.update((state) => imageUrls);
    } on Exception catch (e) {
      _appScaffoldMessengerController.showSnackBarByException(e);
    }
  }
}
