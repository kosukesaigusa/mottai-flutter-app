import 'dart:io';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../image/firebase_storage.dart';
import '../job.dart';

final jobControllerProvider = Provider.autoDispose<JobController>(
  (ref) => JobController(
    jobService: ref.watch(jobServiceProvider),
    firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
  ),
);

class JobController {
  const JobController({
    required JobService jobService,
    required FirebaseStorageService firebaseStorageService,
  })  : _jobService = jobService,
        _firebaseStorageService = firebaseStorageService;

  /// storageの画像を保存するフォルダのパス
  static const _storagePath = 'jobs';

  final JobService _jobService;
  final FirebaseStorageService _firebaseStorageService;

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
    String? imageUrl;
    if (imageFile != null) {
      final imagePath = '$_storagePath/$jobId-${DateTime.now()}.jpg';
      imageUrl = await _firebaseStorageService.upload(
        path: imagePath,
        resource: FirebaseStorageFile(imageFile),
      );
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
}
