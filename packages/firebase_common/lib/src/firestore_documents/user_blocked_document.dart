import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'user_blocked_document.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'userBlockedDocuments/{userId}/jobs',
  documentName: 'job',
)
class BlockedJob {
  const BlockedJob({
    this.createdAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}

@FirestoreDocument(
  path: 'userBlockedDocuments/{userId}/reviews',
  documentName: 'review',
)
class BlockedReview {
  const BlockedReview({
    this.createdAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}
