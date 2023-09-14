import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

@FirestoreDocument(
  path: 'userInappropriateReport',
  documentName: 'userInappropriateReport',
)
class UserInappropriateReport {
  const UserInappropriateReport({
    required this.userId,
    required this.targetId,
    required this.inappropriateContentReportedType,
    this.createdAt,
  });

  final String userId;

  final String targetId;

  @_inappropriateContentReportedTypesConverter
  final InappropriateContentReportedType inappropriateContentReportedType;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}

enum InappropriateContentReportedType {
  job,
  review;

  /// 与えられた文字列に対応する [InappropriateContentReportedType] を返す。
  factory InappropriateContentReportedType.fromString(String str) {
    switch (str) {
      case 'job':
        return InappropriateContentReportedType.job;
      case 'review':
        return InappropriateContentReportedType.review;
    }
    throw ArgumentError('報告種別が正しくありません。');
  }
}

const _inappropriateContentReportedTypesConverter =
    _InappropriateContentReportedTypesConverter();

class _InappropriateContentReportedTypesConverter
    implements JsonConverter<InappropriateContentReportedType, String> {
  const _InappropriateContentReportedTypesConverter();

  @override
  InappropriateContentReportedType fromJson(String json) =>
      InappropriateContentReportedType.fromString(json);

  @override
  String toJson(InappropriateContentReportedType type) => type.toString();
}
