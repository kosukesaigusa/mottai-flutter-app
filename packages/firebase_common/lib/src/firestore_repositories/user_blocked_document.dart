import '../firestore_documents/user_blocked_document.dart';

abstract class UserBlockedDocumentRepository {
  /// [UserBlockedDocument] の情報を作成する。
  Future<void> create({
    required String userId,
    required String targetId,
  });
}

class BlockedJobRepository implements UserBlockedDocumentRepository {
  final _query = BlockedJobQuery();

  /// [BlockedJob] の情報を作成する。
  @override
  Future<void> create({
    required String userId,
    required String targetId,
  }) =>
      _query.set(
        userId: userId,
        jobId: targetId,
        createBlockedJob: CreateBlockedJob(userId: userId),
      );
}

class BlockedReviewRepository implements UserBlockedDocumentRepository {
  final _query = BlockedReviewQuery();

  /// [BlockedReview] の情報を作成する。
  @override
  Future<void> create({
    required String userId,
    required String targetId,
  }) =>
      _query.set(
        userId: userId,
        reviewId: targetId,
        createBlockedReview: CreateBlockedReview(userId: userId),
      );
}
