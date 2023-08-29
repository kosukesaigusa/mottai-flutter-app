import 'dart:io';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../image/firebase_storage.dart';
import '../../user/host.dart';

final hostControllerProvider =
    Provider.family.autoDispose<HostController, String>(
  (ref, userId) => HostController(
    hostService: ref.watch(hostServiceProvider),
    firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
    userId: userId,
  ),
);

class HostController {
  const HostController({
    required HostService hostService,
    required FirebaseStorageService firebaseStorageService,
    required String userId,
  })  : _hostService = hostService,
        _firebaseStorageService = firebaseStorageService,
        _userId = userId;

  /// storageの画像を保存するフォルダのパス
  static const _storagePath = 'hosts';

  final HostService _hostService;
  final FirebaseStorageService _firebaseStorageService;
  final String _userId;

  /// [Host] の情報を作成する。
  Future<void> create({
    required String displayName,
    required String introduction,
    required Set<HostType> hostTypes,
    required List<String> urls,
    required File imageFile,
  }) async {
    final imageUrl = await _uploadImage(imageFile);
    await _hostService.create(
      displayName: displayName,
      introduction: introduction,
      hostTypes: hostTypes,
      urls: urls,
      imageUrl: imageUrl,
    );
  }

  /// [Host] を更新する。
  Future<void> updateHost({
    required String hostId,
    String? displayName,
    String? introduction,
    Set<HostType>? hostTypes,
    List<String>? urls,
    File? imageFile,
  }) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    await _hostService.update(
      hostId: hostId,
      displayName: displayName,
      introduction: introduction,
      hostTypes: hostTypes,
      urls: urls,
      imageUrl: imageUrl,
    );
  }

  Future<String> _uploadImage(File imageFile) {
    final imagePath = '$_storagePath/$_userId-${DateTime.now()}.jpg';
    return _firebaseStorageService.upload(
      path: imagePath,
      resource: FirebaseStorageFile(imageFile),
    );
  }
}
