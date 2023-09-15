import '../firestore_documents/user_inappropriate_report.dart';

class UserInappropriateReportRepository {
  final _query = UserInappropriateReportQuery();

  /// [UserInappropriateReport] の情報を作成する。
  Future<void> create({
    required String userId,
  }) =>
      _query.set(
        userInappropriateReportsId: userId,
        createUserInappropriateReport:
            CreateUserInappropriateReport(userId: userId),
      );
}

class InappropriateReportJobRepository {
  final _query = InappropriateReportJobQuery();

  /// [InappropriateReportJob] の情報を作成する。
  Future<void> create({
    required String userId,
    required String jobId,
  }) =>
      _query.set(
        userId: userId,
        jobId: jobId,
        createInappropriateReportJob:
            CreateInappropriateReportJob(userId: userId),
      );
}

class InappropriateReportReviewRepository {
  final _query = InappropriateReportReviewQuery();

  /// [InappropriateReportReview] の情報を作成する。
  Future<void> create({
    required String userId,
    required String reviewId,
  }) =>
      _query.set(
        userId: userId,
        reviewId: reviewId,
        createInappropriateReportReview:
            CreateInappropriateReportReview(userId: userId),
      );
}
