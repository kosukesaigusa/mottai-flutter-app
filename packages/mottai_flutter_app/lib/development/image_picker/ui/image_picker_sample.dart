import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../../../widgets/dialog/permission_handler_dialog.dart';

@RoutePage()
class ImagePickerSamplePage extends ConsumerStatefulWidget {
  const ImagePickerSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/imagePickerSample';

  /// [ImagePickerSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<ImagePickerSamplePage> createState() =>
      _ImagePickerSamplePageState();
}

class _ImagePickerSamplePageState extends ConsumerState<ImagePickerSamplePage> {
  /// 端末ギャラリーから選択された 1 つの画像。
  File? _pickedImageFromGallery;

  /// 端末カメラで撮影・選択された 1 つの画像。
  File? _pickedImageFromCamera;

  /// 端末ギャラリーから選択された複数の画像。
  final List<File> _pickedImagesFromGallery = <File>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('端末内の画像を選択する機能のサンプル'),
      ),
      body: ListView(
        children: [
          const Gap(60),
          const Center(child: Text('1 枚の画像を選択')),
          if (_pickedImageFromGallery == null)
            GestureDetector(
              onTap: _pickImageFromGallery,
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                  ),
                  child: const Icon(Icons.image),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _pickImageFromGallery,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.file(_pickedImageFromGallery!),
              ),
            ),
          const Gap(60),
          const Center(child: Text('1 枚の画像を撮影して選択')),
          if (_pickedImageFromCamera == null)
            GestureDetector(
              onTap: _pickImageFromCamera,
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                  ),
                  child: const Icon(Icons.image),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _pickImageFromGallery,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.file(_pickedImageFromCamera!),
              ),
            ),
          const Gap(60),
          const Center(child: Text('複数の画像を選択')),
          if (_pickedImagesFromGallery.isEmpty)
            GestureDetector(
              onTap: _pickImagesFromGallery,
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                  ),
                  child: const Icon(Icons.image),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pickedImagesFromGallery.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: _pickImagesFromGallery,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(_pickedImageFromGallery!),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 画像を 1 つ端末のギャラリーから選択する。
  Future<void> _pickImageFromGallery() async {
    final service = ImagePickerService();
    try {
      final path = await service.pickImage(ImageSource.gallery);
      if (path != null) {
        _pickedImageFromGallery = File(path);
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (e.code != 'photo_access_denied') {
        return;
      }
      await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const AccessDeniedDialog.gallery(),
          );
    }
  }

  /// 画像を 1 つ端末のカメラを起動・撮影して選択する。
  Future<void> _pickImageFromCamera() async {
    final service = ImagePickerService();
    try {
      final path = await service.pickImage(ImageSource.camera);
      if (path != null) {
        _pickedImageFromGallery = File(path);
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (e.code != 'camera_access_denied') {
        return;
      }
      await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const AccessDeniedDialog.camera(),
          );
    }
  }

  /// 複数の画像を端末のギャラリーから選択する。
  Future<void> _pickImagesFromGallery() async {
    final service = ImagePickerService();
    try {
      final paths = await service.pickImages();
      if (paths.isNotEmpty) {
        _pickedImagesFromGallery
          ..clear()
          ..addAll(paths.map(File.new));
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (e.code != 'photo_access_denied') {
        return;
      }
      await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const AccessDeniedDialog.camera(),
          );
    }
  }
}
