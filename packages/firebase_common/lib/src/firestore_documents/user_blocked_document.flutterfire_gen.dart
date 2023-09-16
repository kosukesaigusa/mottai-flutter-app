// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_blocked_document.dart';

class ReadUserBlockedDocument {
  const ReadUserBlockedDocument({
    required this.userBlockedDocumentId,
    required this.path,
    required this.userId,
  });

  final String userBlockedDocumentId;

  final String path;

  final String userId;

  factory ReadUserBlockedDocument._fromJson(Map<String, dynamic> json) {
    return ReadUserBlockedDocument(
      userBlockedDocumentId: json['userBlockedDocumentId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
    );
  }

  factory ReadUserBlockedDocument.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUserBlockedDocument._fromJson(<String, dynamic>{
      ...data,
      'userBlockedDocumentId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUserBlockedDocument {
  const CreateUserBlockedDocument({
    required this.userId,
  });

  final String userId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}

class UpdateUserBlockedDocument {
  const UpdateUserBlockedDocument({
    this.userId,
  });

  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
    };
  }
}

class DeleteUserBlockedDocument {}

/// Provides a reference to the userBlockedDocuments collection for reading.
final readUserBlockedDocumentCollectionReference = FirebaseFirestore.instance
    .collection('userBlockedDocuments')
    .withConverter<ReadUserBlockedDocument>(
      fromFirestore: (ds, _) =>
          ReadUserBlockedDocument.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userBlockedDocument document for reading.
DocumentReference<ReadUserBlockedDocument>
    readUserBlockedDocumentDocumentReference({
  required String userBlockedDocumentId,
}) =>
        readUserBlockedDocumentCollectionReference.doc(userBlockedDocumentId);

/// Provides a reference to the userBlockedDocuments collection for creating.
final createUserBlockedDocumentCollectionReference = FirebaseFirestore.instance
    .collection('userBlockedDocuments')
    .withConverter<CreateUserBlockedDocument>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userBlockedDocument document for creating.
DocumentReference<CreateUserBlockedDocument>
    createUserBlockedDocumentDocumentReference({
  required String userBlockedDocumentId,
}) =>
        createUserBlockedDocumentCollectionReference.doc(userBlockedDocumentId);

/// Provides a reference to the userBlockedDocuments collection for updating.
final updateUserBlockedDocumentCollectionReference = FirebaseFirestore.instance
    .collection('userBlockedDocuments')
    .withConverter<UpdateUserBlockedDocument>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userBlockedDocument document for updating.
DocumentReference<UpdateUserBlockedDocument>
    updateUserBlockedDocumentDocumentReference({
  required String userBlockedDocumentId,
}) =>
        updateUserBlockedDocumentCollectionReference.doc(userBlockedDocumentId);

/// Provides a reference to the userBlockedDocuments collection for deleting.
final deleteUserBlockedDocumentCollectionReference = FirebaseFirestore.instance
    .collection('userBlockedDocuments')
    .withConverter<DeleteUserBlockedDocument>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userBlockedDocument document for deleting.
DocumentReference<DeleteUserBlockedDocument>
    deleteUserBlockedDocumentDocumentReference({
  required String userBlockedDocumentId,
}) =>
        deleteUserBlockedDocumentCollectionReference.doc(userBlockedDocumentId);

/// Manages queries against the userBlockedDocuments collection.
class UserBlockedDocumentQuery {
  /// Fetches [ReadUserBlockedDocument] documents.
  Future<List<ReadUserBlockedDocument>> fetchDocuments({
    GetOptions? options,
    Query<ReadUserBlockedDocument>? Function(
            Query<ReadUserBlockedDocument> query)?
        queryBuilder,
    int Function(ReadUserBlockedDocument lhs, ReadUserBlockedDocument rhs)?
        compare,
  }) async {
    Query<ReadUserBlockedDocument> query =
        readUserBlockedDocumentCollectionReference;
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

  /// Subscribes [UserBlockedDocument] documents.
  Stream<List<ReadUserBlockedDocument>> subscribeDocuments({
    Query<ReadUserBlockedDocument>? Function(
            Query<ReadUserBlockedDocument> query)?
        queryBuilder,
    int Function(ReadUserBlockedDocument lhs, ReadUserBlockedDocument rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadUserBlockedDocument> query =
        readUserBlockedDocumentCollectionReference;
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

  /// Fetches a specific [ReadUserBlockedDocument] document.
  Future<ReadUserBlockedDocument?> fetchDocument({
    required String userBlockedDocumentId,
    GetOptions? options,
  }) async {
    final ds = await readUserBlockedDocumentDocumentReference(
      userBlockedDocumentId: userBlockedDocumentId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [UserBlockedDocument] document.
  Stream<ReadUserBlockedDocument?> subscribeDocument({
    required String userBlockedDocumentId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUserBlockedDocumentDocumentReference(
      userBlockedDocumentId: userBlockedDocumentId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [UserBlockedDocument] document.
  Future<DocumentReference<CreateUserBlockedDocument>> add({
    required CreateUserBlockedDocument createUserBlockedDocument,
  }) =>
      createUserBlockedDocumentCollectionReference
          .add(createUserBlockedDocument);

  /// Sets a [UserBlockedDocument] document.
  Future<void> set({
    required String userBlockedDocumentId,
    required CreateUserBlockedDocument createUserBlockedDocument,
    SetOptions? options,
  }) =>
      createUserBlockedDocumentDocumentReference(
        userBlockedDocumentId: userBlockedDocumentId,
      ).set(createUserBlockedDocument, options);

  /// Updates a specific [UserBlockedDocument] document.
  Future<void> update({
    required String userBlockedDocumentId,
    required UpdateUserBlockedDocument updateUserBlockedDocument,
  }) =>
      updateUserBlockedDocumentDocumentReference(
        userBlockedDocumentId: userBlockedDocumentId,
      ).update(updateUserBlockedDocument.toJson());

  /// Deletes a specific [UserBlockedDocument] document.
  Future<void> delete({
    required String userBlockedDocumentId,
  }) =>
      deleteUserBlockedDocumentDocumentReference(
        userBlockedDocumentId: userBlockedDocumentId,
      ).delete();
}

class ReadBlockedJob {
  const ReadBlockedJob({
    required this.jobId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String jobId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadBlockedJob._fromJson(Map<String, dynamic> json) {
    return ReadBlockedJob(
      jobId: json['jobId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadBlockedJob.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadBlockedJob._fromJson(<String, dynamic>{
      ...data,
      'jobId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateBlockedJob {
  const CreateBlockedJob({
    required this.userId,
  });

  final String userId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateBlockedJob {
  const UpdateBlockedJob({
    this.userId,
    this.createdAt,
  });

  final String? userId;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class DeleteBlockedJob {}

/// Provides a reference to the jobs collection for reading.
CollectionReference<ReadBlockedJob> readBlockedJobCollectionReference({
  required String userId,
}) =>
    FirebaseFirestore.instance
        .collection('userBlockedDocuments')
        .doc(userId)
        .collection('jobs')
        .withConverter<ReadBlockedJob>(
          fromFirestore: (ds, _) => ReadBlockedJob.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a job document for reading.
DocumentReference<ReadBlockedJob> readBlockedJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
    readBlockedJobCollectionReference(userId: userId).doc(jobId);

/// Provides a reference to the jobs collection for creating.
CollectionReference<CreateBlockedJob> createBlockedJobCollectionReference({
  required String userId,
}) =>
    FirebaseFirestore.instance
        .collection('userBlockedDocuments')
        .doc(userId)
        .collection('jobs')
        .withConverter<CreateBlockedJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a job document for creating.
DocumentReference<CreateBlockedJob> createBlockedJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
    createBlockedJobCollectionReference(userId: userId).doc(jobId);

/// Provides a reference to the jobs collection for updating.
CollectionReference<UpdateBlockedJob> updateBlockedJobCollectionReference({
  required String userId,
}) =>
    FirebaseFirestore.instance
        .collection('userBlockedDocuments')
        .doc(userId)
        .collection('jobs')
        .withConverter<UpdateBlockedJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a job document for updating.
DocumentReference<UpdateBlockedJob> updateBlockedJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
    updateBlockedJobCollectionReference(userId: userId).doc(jobId);

/// Provides a reference to the jobs collection for deleting.
CollectionReference<DeleteBlockedJob> deleteBlockedJobCollectionReference({
  required String userId,
}) =>
    FirebaseFirestore.instance
        .collection('userBlockedDocuments')
        .doc(userId)
        .collection('jobs')
        .withConverter<DeleteBlockedJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a job document for deleting.
DocumentReference<DeleteBlockedJob> deleteBlockedJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
    deleteBlockedJobCollectionReference(userId: userId).doc(jobId);

/// Manages queries against the jobs collection.
class BlockedJobQuery {
  /// Fetches [ReadBlockedJob] documents.
  Future<List<ReadBlockedJob>> fetchDocuments({
    required String userId,
    GetOptions? options,
    Query<ReadBlockedJob>? Function(Query<ReadBlockedJob> query)? queryBuilder,
    int Function(ReadBlockedJob lhs, ReadBlockedJob rhs)? compare,
  }) async {
    Query<ReadBlockedJob> query =
        readBlockedJobCollectionReference(userId: userId);
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

  /// Subscribes [BlockedJob] documents.
  Stream<List<ReadBlockedJob>> subscribeDocuments({
    required String userId,
    Query<ReadBlockedJob>? Function(Query<ReadBlockedJob> query)? queryBuilder,
    int Function(ReadBlockedJob lhs, ReadBlockedJob rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadBlockedJob> query =
        readBlockedJobCollectionReference(userId: userId);
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

  /// Fetches a specific [ReadBlockedJob] document.
  Future<ReadBlockedJob?> fetchDocument({
    required String userId,
    required String jobId,
    GetOptions? options,
  }) async {
    final ds = await readBlockedJobDocumentReference(
      userId: userId,
      jobId: jobId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [BlockedJob] document.
  Stream<ReadBlockedJob?> subscribeDocument({
    required String userId,
    required String jobId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readBlockedJobDocumentReference(
      userId: userId,
      jobId: jobId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [BlockedJob] document.
  Future<DocumentReference<CreateBlockedJob>> add({
    required String userId,
    required CreateBlockedJob createBlockedJob,
  }) =>
      createBlockedJobCollectionReference(userId: userId).add(createBlockedJob);

  /// Sets a [BlockedJob] document.
  Future<void> set({
    required String userId,
    required String jobId,
    required CreateBlockedJob createBlockedJob,
    SetOptions? options,
  }) =>
      createBlockedJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).set(createBlockedJob, options);

  /// Updates a specific [BlockedJob] document.
  Future<void> update({
    required String userId,
    required String jobId,
    required UpdateBlockedJob updateBlockedJob,
  }) =>
      updateBlockedJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).update(updateBlockedJob.toJson());

  /// Deletes a specific [BlockedJob] document.
  Future<void> delete({
    required String userId,
    required String jobId,
  }) =>
      deleteBlockedJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).delete();
}

class ReadBlockedReview {
  const ReadBlockedReview({
    required this.reviewId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String reviewId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadBlockedReview._fromJson(Map<String, dynamic> json) {
    return ReadBlockedReview(
      reviewId: json['reviewId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadBlockedReview.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadBlockedReview._fromJson(<String, dynamic>{
      ...data,
      'reviewId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateBlockedReview {
  const CreateBlockedReview({
    required this.userId,
  });

  final String userId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateBlockedReview {
  const UpdateBlockedReview({
    this.userId,
    this.createdAt,
  });

  final String? userId;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class DeleteBlockedReview {}

/// Provides a reference to the reviews collection for reading.
CollectionReference<ReadBlockedReview> readBlockedReviewCollectionReference({
  required String userId,
}) =>
    FirebaseFirestore.instance
        .collection('userBlockedDocuments')
        .doc(userId)
        .collection('reviews')
        .withConverter<ReadBlockedReview>(
          fromFirestore: (ds, _) => ReadBlockedReview.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a review document for reading.
DocumentReference<ReadBlockedReview> readBlockedReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
    readBlockedReviewCollectionReference(userId: userId).doc(reviewId);

/// Provides a reference to the reviews collection for creating.
CollectionReference<CreateBlockedReview>
    createBlockedReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userBlockedDocuments')
            .doc(userId)
            .collection('reviews')
            .withConverter<CreateBlockedReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a review document for creating.
DocumentReference<CreateBlockedReview> createBlockedReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
    createBlockedReviewCollectionReference(userId: userId).doc(reviewId);

/// Provides a reference to the reviews collection for updating.
CollectionReference<UpdateBlockedReview>
    updateBlockedReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userBlockedDocuments')
            .doc(userId)
            .collection('reviews')
            .withConverter<UpdateBlockedReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a review document for updating.
DocumentReference<UpdateBlockedReview> updateBlockedReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
    updateBlockedReviewCollectionReference(userId: userId).doc(reviewId);

/// Provides a reference to the reviews collection for deleting.
CollectionReference<DeleteBlockedReview>
    deleteBlockedReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userBlockedDocuments')
            .doc(userId)
            .collection('reviews')
            .withConverter<DeleteBlockedReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a review document for deleting.
DocumentReference<DeleteBlockedReview> deleteBlockedReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
    deleteBlockedReviewCollectionReference(userId: userId).doc(reviewId);

/// Manages queries against the reviews collection.
class BlockedReviewQuery {
  /// Fetches [ReadBlockedReview] documents.
  Future<List<ReadBlockedReview>> fetchDocuments({
    required String userId,
    GetOptions? options,
    Query<ReadBlockedReview>? Function(Query<ReadBlockedReview> query)?
        queryBuilder,
    int Function(ReadBlockedReview lhs, ReadBlockedReview rhs)? compare,
  }) async {
    Query<ReadBlockedReview> query =
        readBlockedReviewCollectionReference(userId: userId);
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

  /// Subscribes [BlockedReview] documents.
  Stream<List<ReadBlockedReview>> subscribeDocuments({
    required String userId,
    Query<ReadBlockedReview>? Function(Query<ReadBlockedReview> query)?
        queryBuilder,
    int Function(ReadBlockedReview lhs, ReadBlockedReview rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadBlockedReview> query =
        readBlockedReviewCollectionReference(userId: userId);
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

  /// Fetches a specific [ReadBlockedReview] document.
  Future<ReadBlockedReview?> fetchDocument({
    required String userId,
    required String reviewId,
    GetOptions? options,
  }) async {
    final ds = await readBlockedReviewDocumentReference(
      userId: userId,
      reviewId: reviewId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [BlockedReview] document.
  Stream<ReadBlockedReview?> subscribeDocument({
    required String userId,
    required String reviewId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readBlockedReviewDocumentReference(
      userId: userId,
      reviewId: reviewId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [BlockedReview] document.
  Future<DocumentReference<CreateBlockedReview>> add({
    required String userId,
    required CreateBlockedReview createBlockedReview,
  }) =>
      createBlockedReviewCollectionReference(userId: userId)
          .add(createBlockedReview);

  /// Sets a [BlockedReview] document.
  Future<void> set({
    required String userId,
    required String reviewId,
    required CreateBlockedReview createBlockedReview,
    SetOptions? options,
  }) =>
      createBlockedReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).set(createBlockedReview, options);

  /// Updates a specific [BlockedReview] document.
  Future<void> update({
    required String userId,
    required String reviewId,
    required UpdateBlockedReview updateBlockedReview,
  }) =>
      updateBlockedReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).update(updateBlockedReview.toJson());

  /// Deletes a specific [BlockedReview] document.
  Future<void> delete({
    required String userId,
    required String reviewId,
  }) =>
      deleteBlockedReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).delete();
}
