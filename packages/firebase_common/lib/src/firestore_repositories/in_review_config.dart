import '../firestore_documents/in_review_config.dart';

class InReviewConfigRepository {
  final _query = InReviewConfigQuery();

  /// [ReadInReviewConfig] を購読する。
  Stream<ReadInReviewConfig?> subscribeInReviewConfig() =>
      _query.subscribeDocument(inReviewConfigId: 'inReviewConfig');
}
