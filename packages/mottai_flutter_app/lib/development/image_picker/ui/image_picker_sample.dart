import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../scaffold_messenger_controller.dart';

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
          const SizedBox(height: 60),
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
          const SizedBox(height: 60),
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
          const SizedBox(height: 60),
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
      final result = await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const _AccessNotDeniedDialog.gallery(),
          );
      if (result ?? false) {
        await openAppSettings();
      }
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
      final result = await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const _AccessNotDeniedDialog.camera(),
          );
      if (result ?? false) {
        await openAppSettings();
      }
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
      final result = await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const _AccessNotDeniedDialog.camera(),
          );
      if (result ?? false) {
        await openAppSettings();
      }
    }
  }
}

/// 端末の画像ライブラリやカメラへのアクセスが許可されていない場合に表示する
/// [AlertDialog]. permission_handler パッケージの [openAppSettings] メソッドで
/// 設定画面に進ませる。
class _AccessNotDeniedDialog extends StatelessWidget {
  const _AccessNotDeniedDialog.gallery() : _imageSource = ImageSource.gallery;

  const _AccessNotDeniedDialog.camera() : _imageSource = ImageSource.camera;

  final ImageSource _imageSource;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('設定画面へ'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  String get _title {
    switch (_imageSource) {
      case ImageSource.gallery:
        return '端末の画像の使用が許可されていません。';
      case ImageSource.camera:
        return '端末のカメラの使用が許可されていません。';
    }
  }

  String get _content {
    switch (_imageSource) {
      case ImageSource.gallery:
        return '端末の画像ライブラリの使用が許可されていません。'
            '端末の設定画面へ進み、画像ライブラリの使用を許可してください。';
      case ImageSource.camera:
        return 'カメラの使用が許可されていません。'
            '端末の設定画面へ進み、カメラの使用を許可してください。';
    }
  }
}
