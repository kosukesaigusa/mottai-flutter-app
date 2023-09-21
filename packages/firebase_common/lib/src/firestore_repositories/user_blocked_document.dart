import '../firestore_documents/user_blocked_document.dart';

class BlockedJobRepository {
  final _query = BlockedJobQuery();

  /// [BlockedJob] の情報を作成する。
  Future<void> create({
    required String userId,
    required String jobId,
  }) =>
      _query.set(
        userId: userId,
        jobId: jobId,
        createBlockedJob: const CreateBlockedJob(),
      );
}

class BlockedReviewRepository {
  final _query = BlockedReviewQuery();

  /// [BlockedReview] の情報を作成する。
  Future<void> create({
    required String userId,
    required String reviewId,
  }) =>
      _query.set(
        userId: userId,
        reviewId: reviewId,
        createBlockedReview: const CreateBlockedReview(),
      );
}
