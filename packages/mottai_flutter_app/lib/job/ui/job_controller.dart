import 'dart:io';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../image/firebase_storage.dart';
import '../job.dart';

final jobControllerProvider = Provider.autoDispose<JobController>(
  (ref) => JobController(
    jobService: ref.watch(jobServiceProvider),
    firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
    userId: ref.watch(userIdProvider),
  ),
);

class JobController {
  const JobController({
    required JobService jobService,
    required FirebaseStorageService firebaseStorageService,
    String? userId,
  })  : _jobService = jobService,
        _firebaseStorageService = firebaseStorageService,
        _userId = userId;

  /// storageの画像を保存するフォルダのパス
  static const _storagePath = 'jobs';

  final JobService _jobService;
  final FirebaseStorageService _firebaseStorageService;
  final String? _userId;

  //TODO: 必須入力のバリデーション
  /// [Job] の情報を作成する。
  Future<void> create({
    required String title,
    required String content,
    required String place,
    required Set<AccessType> accessTypes,
    required String accessDescription,
    required String belongings,
    required String reward,
    required String comment,
    File? imageFile,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return;
    }

    var imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    await _jobService.create(
      hostId: userId,
      title: title,
      content: content,
      place: place,
      accessTypes: accessTypes,
      accessDescription: accessDescription,
      belongings: belongings,
      reward: reward,
      comment: comment,
      imageUrl: imageUrl,
    );
  }

  /// [Job] を更新する。
  Future<void> updateJob({
    required String jobId,
    String? title,
    String? content,
    String? place,
    Set<AccessType>? accessTypes,
    String? accessDescription,
    String? belongings,
    String? reward,
    String? comment,
    File? imageFile,
  }) async {
    final userId = _userId;
    if (userId == null) {
      return;
    }

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    await _jobService.update(
      jobId: jobId,
      title: title,
      content: content,
      place: place,
      accessTypes: accessTypes,
      accessDescription: accessDescription,
      belongings: belongings,
      reward: reward,
      comment: comment,
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
