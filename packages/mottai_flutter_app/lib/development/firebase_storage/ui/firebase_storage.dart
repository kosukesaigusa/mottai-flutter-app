import 'package:auto_route/auto_route.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firebase_storage.dart';
import 'firebase_storage_controller.dart';

@RoutePage()
class FirebaseStorageSamplePage extends ConsumerStatefulWidget {
  const FirebaseStorageSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/firebaseStorageSample';

  /// [FirebaseStorageSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<FirebaseStorageSamplePage> createState() =>
      _FirebaseStorageSampleState();
}

class _FirebaseStorageSampleState
    extends ConsumerState<FirebaseStorageSamplePage> {
  /// storageの画像を保存するフォルダのパス
  static const _storagePath = 'sample';

  @override
  void initState() {
    ref.read(firebaseStorageControllerProvider).fetchImageUrls(_storagePath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(firebaseStorageControllerProvider);
    final pickedImageFile = ref.watch(pickedImageFileStateProvider);
    final uploadedImageUrl = ref.watch(uploadedImageUrlStateProvider);

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
              children: ref
                  .watch(imageUrlsStateProvider)
                  .map(Image.network)
                  .take(5)
                  .toList(),
            ),
          ),
          if (pickedImageFile == null)
            GestureDetector(
              onTap: controller.pickImageFromGallery,
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
              onTap: controller.pickImageFromGallery,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.file(pickedImageFile),
              ),
            ),
          const Gap(8),
          ElevatedButton(
            onPressed: () {
              if (pickedImageFile != null) {
                controller.uploadImage(
                  path: _storagePath,
                  resource: FirebaseStorageFile(pickedImageFile),
                );
              }
            },
            child: const Text('UPLOAD'),
          ),
          const Gap(20),
          const Text('FirebaseStorageにアップロードされた画像↓'),
          if (uploadedImageUrl != '')
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => controller.deleteImage(
                    ref.watch(uploadedImagePathStateProvider),
                  ),
                  child: const Text('DELETE'),
                ),
                Text(uploadedImageUrl),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(uploadedImageUrl),
                ),
              ],
            )
          else
            const Center(
              child: Text('未アップロード'),
            )
        ],
      ),
    );
  }
}
