import '../firestore_documents/user_inappropriate_report.dart';

abstract class UserInappropriateReportRepository {
  /// [UserInappropriateReport] の情報を作成する。
  Future<void> create({
    required String userId,
    required String targetId,
  });
}

class InappropriateReportJobRepository
    implements UserInappropriateReportRepository {
  final _query = InappropriateReportJobQuery();

  /// [InappropriateReportJob] の情報を作成する。
  @override
  Future<void> create({
    required String userId,
    required String targetId,
  }) =>
      _query.set(
        userId: userId,
        jobId: targetId,
        createInappropriateReportJob:
            CreateInappropriateReportJob(userId: userId),
      );
}

class InappropriateReportReviewRepository
    implements UserInappropriateReportRepository {
  final _query = InappropriateReportReviewQuery();

  /// [InappropriateReportReview] の情報を作成する。
  @override
  Future<void> create({
    required String userId,
    required String targetId,
  }) =>
      _query.set(
        userId: userId,
        reviewId: targetId,
        createInappropriateReportReview:
            CreateInappropriateReportReview(userId: userId),
      );
}
