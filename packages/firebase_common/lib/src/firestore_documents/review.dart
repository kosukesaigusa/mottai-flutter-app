import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'review.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'reviews',
  documentName: 'review',
)
class Review {
  const Review({
    required this.workerId,
    required this.jobId,
    this.imageUrl = '',
    this.title = '',
    this.content = '',
    this.createdAt,
    this.updatedAt,
  });

  final String workerId;

  final String jobId;

  @ReadDefault('')
  final String imageUrl;

  @ReadDefault('')
  final String title;

  @ReadDefault('')
  final String content;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
