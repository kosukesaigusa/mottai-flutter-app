import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

final blockJobServiceProvider = Provider.autoDispose<BlockJobService>(
  (ref) => BlockJobService(
    blockJobRepository: ref.watch(blockedJobRepositoryProvider),
  ),
);

final blockReviewServiceProvider = Provider.autoDispose<BlockReviewService>(
  (ref) => BlockReviewService(
    blockReviewRepository: ref.watch(blockedReviewRepositoryProvider),
  ),
);

class BlockJobService {
  const BlockJobService({
    required BlockedJobRepository blockJobRepository,
  }) : _blockJobRepository = blockJobRepository;

  final BlockedJobRepository _blockJobRepository;

  /// 指定したユーザー ([userId]) が、指定したお手伝い情報 ([jobId]) をブロックする。
  Future<void> create({
    required String userId,
    required String jobId,
  }) =>
      _blockJobRepository.create(userId: userId, jobId: jobId);
}

class BlockReviewService {
  const BlockReviewService({
    required BlockedReviewRepository blockReviewRepository,
  }) : _blockReviewRepository = blockReviewRepository;

  final BlockedReviewRepository _blockReviewRepository;

  /// 指定したユーザー ([userId]) が、指定したレビュー ([reviewId]) をブロックする。
  Future<void> create({
    required String userId,
    required String reviewId,
  }) =>
      _blockReviewRepository.create(userId: userId, reviewId: reviewId);
}
