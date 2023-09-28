import 'dart:io';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../image/firebase_storage.dart';
import '../review.dart';

final reviewControllerProvider = Provider.autoDispose<ReviewController>(
  (ref) => ReviewController(
    reviewService: ref.watch(reviewServiceProvider),
    firebaseStorageService: ref.watch(firebaseStorageServiceProvider),
  ),
);

class ReviewController {
  const ReviewController({
    required ReviewService reviewService,
    required FirebaseStorageService firebaseStorageService,
  })  : _reviewService = reviewService,
        _firebaseStorageService = firebaseStorageService;

  /// storageの画像を保存するフォルダのパス
  static const _storagePath = 'reviews';

  final ReviewService _reviewService;
  final FirebaseStorageService _firebaseStorageService;

  /// [Review] の情報を作成する。
  Future<void> create({
    required String workerId,
    required String jobId,
    required String title,
    required String content,
    File? imageFile,
  }) async {
    var imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImage(
        imageFile,
        workerId,
      );
    }
    await _reviewService.create(
      workerId: workerId,
      jobId: jobId,
      title: title,
      content: content,
      imageUrl: imageUrl,
    );
  }

  /// [Review] を更新する。
  Future<void> updateReview({
    required String reviewId,
    required String workerId,
    String? title,
    String? content,
    File? imageFile,
  }) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(
        imageFile,
        workerId,
      );
    }
    await _reviewService.update(
      reviewId: reviewId,
      title: title,
      content: content,
      imageUrl: imageUrl,
    );
  }

  Future<String> _uploadImage(
    File imageFile,
    String workerId,
  ) {
    final imagePath = '$_storagePath/$workerId-${DateTime.now()}.jpg';
    return _firebaseStorageService.upload(
      path: imagePath,
      resource: FirebaseStorageFile(imageFile),
    );
  }
}
