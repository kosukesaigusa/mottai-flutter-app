import 'dart:io';
import 'dart:math';

import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../scaffold_messenger_controller.dart';
import '../../image_picker/ui/image_picker_sample.dart';

class FirebaseStorageSamplePage extends ConsumerStatefulWidget {
  const FirebaseStorageSamplePage({super.key});

  @override
  ConsumerState<FirebaseStorageSamplePage> createState() =>
      _FirebaseStorageSampleState();
}

class _FirebaseStorageSampleState
    extends ConsumerState<FirebaseStorageSamplePage> {
  /// 端末ギャラリーから選択された 1 つの画像。
  File? _pickedImageFromGallery;

  /// FirebaseStorageにアップロードした画像のURL。
  String _uploadedImageUrl = '';

  /// FirebaseStorageにアップロードした画像のPath。
  String _uploadedImagePath = '';

  /// FirebaseStorageから取得した画像のURLのリスト。
  List<String> _imageUrls = [];
  final _firebaseStorageService = FirebaseStorageService();

  @override
  void initState() {
    fetchImageUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirebaseStorageを使用するサンプル画面'),
      ),
      body: ListView(
        children: [
          const Gap(8),
          SizedBox(
            height: 100,
            child: GridView.count(
              crossAxisCount: 5,
              children: _imageUrls
                  .map(
                    Image.network,
                  )
                  .take(5)
                  .toList(),
            ),
          ),
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
          const Gap(8),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('UPLOAD'),
          ),
          const Gap(20),
          const Text('FirebaseStorageにアップロードされた画像↓'),
          if (_uploadedImageUrl != '')
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _deleteImage,
                    child: const Text('DELETE'),
                  ),
                  Text(_uploadedImageUrl),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(_uploadedImageUrl),
                  ),
                ],
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text('未アップロード'),
              ),
            )
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
        setState(() {
          _pickedImageFromGallery = File(path);
        });
      }
    } on PlatformException catch (e) {
      if (e.code != 'photo_access_denied') {
        return;
      }
      final result = await ref
          .read(appScaffoldMessengerControllerProvider)
          .showDialogByBuilder<bool>(
            builder: (context) => const AccessNotDeniedDialog.gallery(),
          );
      if (result ?? false) {
        await openAppSettings();
      }
    }
  }

  /// 画像を FirebaseStorageに アップロードする
  Future<void> _uploadImage() async {
    if (_pickedImageFromGallery == null) {
      return;
    }
    try {
      _uploadedImagePath = 'sample/${Random().nextDouble()}.jpg';
      final imageUrl = await _firebaseStorageService.upload(
        path: _uploadedImagePath,
        resource: FirebaseStorageFile(_pickedImageFromGallery!),
      );
      setState(() {
        _uploadedImageUrl = imageUrl;
      });
    } on Exception {
      return;
    }
  }

  /// FirebaseStorage にアップロードされたファイルを削除する
  Future<void> _deleteImage() async {
    try {
      await _firebaseStorageService.delete(path: _uploadedImagePath);
      setState(() {
        _uploadedImageUrl = '';
        _uploadedImagePath = '';
      });
    } on Exception {
      return;
    }
  }

  /// FirebaseStorage から imageUrl のリストを取得する
  Future<void> fetchImageUrls() async {
    final listResult =
        await _firebaseStorageService.fetchAllReferences(path: 'sample/');
    final futureImageUrls = listResult.items
        .map((reference) => reference.getDownloadURL())
        .toList();
    final imageUrls = await Future.wait(futureImageUrls);
    setState(() {
      _imageUrls = imageUrls;
    });
  }
}
