import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
part 'user_inappropriate_report.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'userInappropriateReports',
  documentName: 'userInappropriateReports',
)
class UserInappropriateReport {
  const UserInappropriateReport({
    required this.userId,
  });

  final String userId; //FIXME: 要素なしだと生成できない？ので追加
}

@FirestoreDocument(
  path: 'userInappropriateReports/{userId}/jobs',
  documentName: 'job',
)
class InappropriateReportJob {
  const InappropriateReportJob({
    this.createdAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}

@FirestoreDocument(
  path: 'userInappropriateReports/{userId}/reviews',
  documentName: 'review',
)
class InappropriateReportReview {
  const InappropriateReportReview({
    this.createdAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}
