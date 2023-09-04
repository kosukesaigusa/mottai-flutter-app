// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

class ReadReview {
  const ReadReview({
    required this.reviewId,
    required this.path,
    required this.workerId,
    required this.jobId,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final String reviewId;

  final String path;

  final String workerId;

  final String jobId;

  final String imageUrl;

  final String title;

  final String content;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadReview._fromJson(Map<String, dynamic> json) {
    return ReadReview(
      reviewId: json['reviewId'] as String,
      path: json['path'] as String,
      workerId: json['workerId'] as String,
      jobId: json['jobId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadReview.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadReview._fromJson(<String, dynamic>{
      ...data,
      'reviewId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateReview {
  const CreateReview({
    required this.workerId,
    required this.jobId,
    required this.imageUrl,
    required this.title,
    required this.content,
  });

  final String workerId;
  final String jobId;
  final String imageUrl;
  final String title;
  final String content;

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'jobId': jobId,
      'imageUrl': imageUrl,
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateReview {
  const UpdateReview({
    this.workerId,
    this.jobId,
    this.imageUrl,
    this.title,
    this.content,
    this.createdAt,
  });

  final String? workerId;
  final String? jobId;
  final String? imageUrl;
  final String? title;
  final String? content;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (workerId != null) 'workerId': workerId,
      if (jobId != null) 'jobId': jobId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteReview {}

/// Provides a reference to the reviews collection for reading.
final readReviewCollectionReference =
    FirebaseFirestore.instance.collection('reviews').withConverter<ReadReview>(
          fromFirestore: (ds, _) => ReadReview.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a review document for reading.
DocumentReference<ReadReview> readReviewDocumentReference({
  required String reviewId,
}) =>
    readReviewCollectionReference.doc(reviewId);

/// Provides a reference to the reviews collection for creating.
final createReviewCollectionReference = FirebaseFirestore.instance
    .collection('reviews')
    .withConverter<CreateReview>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a review document for creating.
DocumentReference<CreateReview> createReviewDocumentReference({
  required String reviewId,
}) =>
    createReviewCollectionReference.doc(reviewId);

/// Provides a reference to the reviews collection for updating.
final updateReviewCollectionReference = FirebaseFirestore.instance
    .collection('reviews')
    .withConverter<UpdateReview>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a review document for updating.
DocumentReference<UpdateReview> updateReviewDocumentReference({
  required String reviewId,
}) =>
    updateReviewCollectionReference.doc(reviewId);

/// Provides a reference to the reviews collection for deleting.
final deleteReviewCollectionReference = FirebaseFirestore.instance
    .collection('reviews')
    .withConverter<DeleteReview>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a review document for deleting.
DocumentReference<DeleteReview> deleteReviewDocumentReference({
  required String reviewId,
}) =>
    deleteReviewCollectionReference.doc(reviewId);

/// Manages queries against the reviews collection.
class ReviewQuery {
  /// Fetches [ReadReview] documents.
  Future<List<ReadReview>> fetchDocuments({
    GetOptions? options,
    Query<ReadReview>? Function(Query<ReadReview> query)? queryBuilder,
    int Function(ReadReview lhs, ReadReview rhs)? compare,
  }) async {
    Query<ReadReview> query = readReviewCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(options);
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Subscribes [Review] documents.
  Stream<List<ReadReview>> subscribeDocuments({
    Query<ReadReview>? Function(Query<ReadReview> query)? queryBuilder,
    int Function(ReadReview lhs, ReadReview rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadReview> query = readReviewCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    var streamQs =
        query.snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamQs = streamQs.where((qs) => !qs.metadata.hasPendingWrites);
    }
    return streamQs.map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// Fetches a specific [ReadReview] document.
  Future<ReadReview?> fetchDocument({
    required String reviewId,
    GetOptions? options,
  }) async {
    final ds = await readReviewDocumentReference(
      reviewId: reviewId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Review] document.
  Stream<ReadReview?> subscribeDocument({
    required String reviewId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readReviewDocumentReference(
      reviewId: reviewId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Review] document.
  Future<DocumentReference<CreateReview>> add({
    required CreateReview createReview,
  }) =>
      createReviewCollectionReference.add(createReview);

  /// Sets a [Review] document.
  Future<void> set({
    required String reviewId,
    required CreateReview createReview,
    SetOptions? options,
  }) =>
      createReviewDocumentReference(
        reviewId: reviewId,
      ).set(createReview, options);

  /// Updates a specific [Review] document.
  Future<void> update({
    required String reviewId,
    required UpdateReview updateReview,
  }) =>
      updateReviewDocumentReference(
        reviewId: reviewId,
      ).update(updateReview.toJson());

  /// Deletes a specific [Review] document.
  Future<void> delete({
    required String reviewId,
  }) =>
      deleteReviewDocumentReference(
        reviewId: reviewId,
      ).delete();
}
