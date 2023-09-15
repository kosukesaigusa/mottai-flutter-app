// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_inappropriate_report.dart';

class ReadUserInappropriateReport {
  const ReadUserInappropriateReport({
    required this.userInappropriateReportsId,
    required this.path,
    required this.userId,
  });

  final String userInappropriateReportsId;

  final String path;

  final String userId;

  factory ReadUserInappropriateReport._fromJson(Map<String, dynamic> json) {
    return ReadUserInappropriateReport(
      userInappropriateReportsId: json['userInappropriateReportsId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
    );
  }

  factory ReadUserInappropriateReport.fromDocumentSnapshot(
      DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUserInappropriateReport._fromJson(<String, dynamic>{
      ...data,
      'userInappropriateReportsId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUserInappropriateReport {
  const CreateUserInappropriateReport({
    required this.userId,
  });

  final String userId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}

class UpdateUserInappropriateReport {
  const UpdateUserInappropriateReport({
    this.userId,
  });

  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
    };
  }
}

class DeleteUserInappropriateReport {}

/// Provides a reference to the userInappropriateReports collection for reading.
final readUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReports')
    .withConverter<ReadUserInappropriateReport>(
      fromFirestore: (ds, _) =>
          ReadUserInappropriateReport.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userInappropriateReports document for reading.
DocumentReference<ReadUserInappropriateReport>
    readUserInappropriateReportDocumentReference({
  required String userInappropriateReportsId,
}) =>
        readUserInappropriateReportCollectionReference
            .doc(userInappropriateReportsId);

/// Provides a reference to the userInappropriateReports collection for creating.
final createUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReports')
    .withConverter<CreateUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userInappropriateReports document for creating.
DocumentReference<CreateUserInappropriateReport>
    createUserInappropriateReportDocumentReference({
  required String userInappropriateReportsId,
}) =>
        createUserInappropriateReportCollectionReference
            .doc(userInappropriateReportsId);

/// Provides a reference to the userInappropriateReports collection for updating.
final updateUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReports')
    .withConverter<UpdateUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userInappropriateReports document for updating.
DocumentReference<UpdateUserInappropriateReport>
    updateUserInappropriateReportDocumentReference({
  required String userInappropriateReportsId,
}) =>
        updateUserInappropriateReportCollectionReference
            .doc(userInappropriateReportsId);

/// Provides a reference to the userInappropriateReports collection for deleting.
final deleteUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReports')
    .withConverter<DeleteUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userInappropriateReports document for deleting.
DocumentReference<DeleteUserInappropriateReport>
    deleteUserInappropriateReportDocumentReference({
  required String userInappropriateReportsId,
}) =>
        deleteUserInappropriateReportCollectionReference
            .doc(userInappropriateReportsId);

/// Manages queries against the userInappropriateReports collection.
class UserInappropriateReportQuery {
  /// Fetches [ReadUserInappropriateReport] documents.
  Future<List<ReadUserInappropriateReport>> fetchDocuments({
    GetOptions? options,
    Query<ReadUserInappropriateReport>? Function(
            Query<ReadUserInappropriateReport> query)?
        queryBuilder,
    int Function(
            ReadUserInappropriateReport lhs, ReadUserInappropriateReport rhs)?
        compare,
  }) async {
    Query<ReadUserInappropriateReport> query =
        readUserInappropriateReportCollectionReference;
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

  /// Subscribes [UserInappropriateReport] documents.
  Stream<List<ReadUserInappropriateReport>> subscribeDocuments({
    Query<ReadUserInappropriateReport>? Function(
            Query<ReadUserInappropriateReport> query)?
        queryBuilder,
    int Function(
            ReadUserInappropriateReport lhs, ReadUserInappropriateReport rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadUserInappropriateReport> query =
        readUserInappropriateReportCollectionReference;
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

  /// Fetches a specific [ReadUserInappropriateReport] document.
  Future<ReadUserInappropriateReport?> fetchDocument({
    required String userInappropriateReportsId,
    GetOptions? options,
  }) async {
    final ds = await readUserInappropriateReportDocumentReference(
      userInappropriateReportsId: userInappropriateReportsId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [UserInappropriateReport] document.
  Stream<ReadUserInappropriateReport?> subscribeDocument({
    required String userInappropriateReportsId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUserInappropriateReportDocumentReference(
      userInappropriateReportsId: userInappropriateReportsId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [UserInappropriateReport] document.
  Future<DocumentReference<CreateUserInappropriateReport>> add({
    required CreateUserInappropriateReport createUserInappropriateReport,
  }) =>
      createUserInappropriateReportCollectionReference
          .add(createUserInappropriateReport);

  /// Sets a [UserInappropriateReport] document.
  Future<void> set({
    required String userInappropriateReportsId,
    required CreateUserInappropriateReport createUserInappropriateReport,
    SetOptions? options,
  }) =>
      createUserInappropriateReportDocumentReference(
        userInappropriateReportsId: userInappropriateReportsId,
      ).set(createUserInappropriateReport, options);

  /// Updates a specific [UserInappropriateReport] document.
  Future<void> update({
    required String userInappropriateReportsId,
    required UpdateUserInappropriateReport updateUserInappropriateReport,
  }) =>
      updateUserInappropriateReportDocumentReference(
        userInappropriateReportsId: userInappropriateReportsId,
      ).update(updateUserInappropriateReport.toJson());

  /// Deletes a specific [UserInappropriateReport] document.
  Future<void> delete({
    required String userInappropriateReportsId,
  }) =>
      deleteUserInappropriateReportDocumentReference(
        userInappropriateReportsId: userInappropriateReportsId,
      ).delete();
}

class ReadInappropriateReportJob {
  const ReadInappropriateReportJob({
    required this.jobId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String jobId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadInappropriateReportJob._fromJson(Map<String, dynamic> json) {
    return ReadInappropriateReportJob(
      jobId: json['jobId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadInappropriateReportJob.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadInappropriateReportJob._fromJson(<String, dynamic>{
      ...data,
      'jobId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateInappropriateReportJob {
  const CreateInappropriateReportJob({
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

class UpdateInappropriateReportJob {
  const UpdateInappropriateReportJob({
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

class DeleteInappropriateReportJob {}

/// Provides a reference to the jobs collection for reading.
CollectionReference<ReadInappropriateReportJob>
    readInappropriateReportJobCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('jobs')
            .withConverter<ReadInappropriateReportJob>(
              fromFirestore: (ds, _) =>
                  ReadInappropriateReportJob.fromDocumentSnapshot(ds),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a job document for reading.
DocumentReference<ReadInappropriateReportJob>
    readInappropriateReportJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
        readInappropriateReportJobCollectionReference(userId: userId)
            .doc(jobId);

/// Provides a reference to the jobs collection for creating.
CollectionReference<CreateInappropriateReportJob>
    createInappropriateReportJobCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('jobs')
            .withConverter<CreateInappropriateReportJob>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a job document for creating.
DocumentReference<CreateInappropriateReportJob>
    createInappropriateReportJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
        createInappropriateReportJobCollectionReference(userId: userId)
            .doc(jobId);

/// Provides a reference to the jobs collection for updating.
CollectionReference<UpdateInappropriateReportJob>
    updateInappropriateReportJobCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('jobs')
            .withConverter<UpdateInappropriateReportJob>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a job document for updating.
DocumentReference<UpdateInappropriateReportJob>
    updateInappropriateReportJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
        updateInappropriateReportJobCollectionReference(userId: userId)
            .doc(jobId);

/// Provides a reference to the jobs collection for deleting.
CollectionReference<DeleteInappropriateReportJob>
    deleteInappropriateReportJobCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('jobs')
            .withConverter<DeleteInappropriateReportJob>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a job document for deleting.
DocumentReference<DeleteInappropriateReportJob>
    deleteInappropriateReportJobDocumentReference({
  required String userId,
  required String jobId,
}) =>
        deleteInappropriateReportJobCollectionReference(userId: userId)
            .doc(jobId);

/// Manages queries against the jobs collection.
class InappropriateReportJobQuery {
  /// Fetches [ReadInappropriateReportJob] documents.
  Future<List<ReadInappropriateReportJob>> fetchDocuments({
    required String userId,
    GetOptions? options,
    Query<ReadInappropriateReportJob>? Function(
            Query<ReadInappropriateReportJob> query)?
        queryBuilder,
    int Function(
            ReadInappropriateReportJob lhs, ReadInappropriateReportJob rhs)?
        compare,
  }) async {
    Query<ReadInappropriateReportJob> query =
        readInappropriateReportJobCollectionReference(userId: userId);
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

  /// Subscribes [InappropriateReportJob] documents.
  Stream<List<ReadInappropriateReportJob>> subscribeDocuments({
    required String userId,
    Query<ReadInappropriateReportJob>? Function(
            Query<ReadInappropriateReportJob> query)?
        queryBuilder,
    int Function(
            ReadInappropriateReportJob lhs, ReadInappropriateReportJob rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadInappropriateReportJob> query =
        readInappropriateReportJobCollectionReference(userId: userId);
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

  /// Fetches a specific [ReadInappropriateReportJob] document.
  Future<ReadInappropriateReportJob?> fetchDocument({
    required String userId,
    required String jobId,
    GetOptions? options,
  }) async {
    final ds = await readInappropriateReportJobDocumentReference(
      userId: userId,
      jobId: jobId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [InappropriateReportJob] document.
  Stream<ReadInappropriateReportJob?> subscribeDocument({
    required String userId,
    required String jobId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readInappropriateReportJobDocumentReference(
      userId: userId,
      jobId: jobId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [InappropriateReportJob] document.
  Future<DocumentReference<CreateInappropriateReportJob>> add({
    required String userId,
    required CreateInappropriateReportJob createInappropriateReportJob,
  }) =>
      createInappropriateReportJobCollectionReference(userId: userId)
          .add(createInappropriateReportJob);

  /// Sets a [InappropriateReportJob] document.
  Future<void> set({
    required String userId,
    required String jobId,
    required CreateInappropriateReportJob createInappropriateReportJob,
    SetOptions? options,
  }) =>
      createInappropriateReportJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).set(createInappropriateReportJob, options);

  /// Updates a specific [InappropriateReportJob] document.
  Future<void> update({
    required String userId,
    required String jobId,
    required UpdateInappropriateReportJob updateInappropriateReportJob,
  }) =>
      updateInappropriateReportJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).update(updateInappropriateReportJob.toJson());

  /// Deletes a specific [InappropriateReportJob] document.
  Future<void> delete({
    required String userId,
    required String jobId,
  }) =>
      deleteInappropriateReportJobDocumentReference(
        userId: userId,
        jobId: jobId,
      ).delete();
}

class ReadInappropriateReportReview {
  const ReadInappropriateReportReview({
    required this.reviewId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String reviewId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadInappropriateReportReview._fromJson(Map<String, dynamic> json) {
    return ReadInappropriateReportReview(
      reviewId: json['reviewId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadInappropriateReportReview.fromDocumentSnapshot(
      DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadInappropriateReportReview._fromJson(<String, dynamic>{
      ...data,
      'reviewId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateInappropriateReportReview {
  const CreateInappropriateReportReview({
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

class UpdateInappropriateReportReview {
  const UpdateInappropriateReportReview({
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

class DeleteInappropriateReportReview {}

/// Provides a reference to the reviews collection for reading.
CollectionReference<ReadInappropriateReportReview>
    readInappropriateReportReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('reviews')
            .withConverter<ReadInappropriateReportReview>(
              fromFirestore: (ds, _) =>
                  ReadInappropriateReportReview.fromDocumentSnapshot(ds),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a review document for reading.
DocumentReference<ReadInappropriateReportReview>
    readInappropriateReportReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
        readInappropriateReportReviewCollectionReference(userId: userId)
            .doc(reviewId);

/// Provides a reference to the reviews collection for creating.
CollectionReference<CreateInappropriateReportReview>
    createInappropriateReportReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('reviews')
            .withConverter<CreateInappropriateReportReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a review document for creating.
DocumentReference<CreateInappropriateReportReview>
    createInappropriateReportReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
        createInappropriateReportReviewCollectionReference(userId: userId)
            .doc(reviewId);

/// Provides a reference to the reviews collection for updating.
CollectionReference<UpdateInappropriateReportReview>
    updateInappropriateReportReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('reviews')
            .withConverter<UpdateInappropriateReportReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a review document for updating.
DocumentReference<UpdateInappropriateReportReview>
    updateInappropriateReportReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
        updateInappropriateReportReviewCollectionReference(userId: userId)
            .doc(reviewId);

/// Provides a reference to the reviews collection for deleting.
CollectionReference<DeleteInappropriateReportReview>
    deleteInappropriateReportReviewCollectionReference({
  required String userId,
}) =>
        FirebaseFirestore.instance
            .collection('userInappropriateReports')
            .doc(userId)
            .collection('reviews')
            .withConverter<DeleteInappropriateReportReview>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a review document for deleting.
DocumentReference<DeleteInappropriateReportReview>
    deleteInappropriateReportReviewDocumentReference({
  required String userId,
  required String reviewId,
}) =>
        deleteInappropriateReportReviewCollectionReference(userId: userId)
            .doc(reviewId);

/// Manages queries against the reviews collection.
class InappropriateReportReviewQuery {
  /// Fetches [ReadInappropriateReportReview] documents.
  Future<List<ReadInappropriateReportReview>> fetchDocuments({
    required String userId,
    GetOptions? options,
    Query<ReadInappropriateReportReview>? Function(
            Query<ReadInappropriateReportReview> query)?
        queryBuilder,
    int Function(ReadInappropriateReportReview lhs,
            ReadInappropriateReportReview rhs)?
        compare,
  }) async {
    Query<ReadInappropriateReportReview> query =
        readInappropriateReportReviewCollectionReference(userId: userId);
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

  /// Subscribes [InappropriateReportReview] documents.
  Stream<List<ReadInappropriateReportReview>> subscribeDocuments({
    required String userId,
    Query<ReadInappropriateReportReview>? Function(
            Query<ReadInappropriateReportReview> query)?
        queryBuilder,
    int Function(ReadInappropriateReportReview lhs,
            ReadInappropriateReportReview rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadInappropriateReportReview> query =
        readInappropriateReportReviewCollectionReference(userId: userId);
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

  /// Fetches a specific [ReadInappropriateReportReview] document.
  Future<ReadInappropriateReportReview?> fetchDocument({
    required String userId,
    required String reviewId,
    GetOptions? options,
  }) async {
    final ds = await readInappropriateReportReviewDocumentReference(
      userId: userId,
      reviewId: reviewId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [InappropriateReportReview] document.
  Stream<ReadInappropriateReportReview?> subscribeDocument({
    required String userId,
    required String reviewId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readInappropriateReportReviewDocumentReference(
      userId: userId,
      reviewId: reviewId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [InappropriateReportReview] document.
  Future<DocumentReference<CreateInappropriateReportReview>> add({
    required String userId,
    required CreateInappropriateReportReview createInappropriateReportReview,
  }) =>
      createInappropriateReportReviewCollectionReference(userId: userId)
          .add(createInappropriateReportReview);

  /// Sets a [InappropriateReportReview] document.
  Future<void> set({
    required String userId,
    required String reviewId,
    required CreateInappropriateReportReview createInappropriateReportReview,
    SetOptions? options,
  }) =>
      createInappropriateReportReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).set(createInappropriateReportReview, options);

  /// Updates a specific [InappropriateReportReview] document.
  Future<void> update({
    required String userId,
    required String reviewId,
    required UpdateInappropriateReportReview updateInappropriateReportReview,
  }) =>
      updateInappropriateReportReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).update(updateInappropriateReportReview.toJson());

  /// Deletes a specific [InappropriateReportReview] document.
  Future<void> delete({
    required String userId,
    required String reviewId,
  }) =>
      deleteInappropriateReportReviewDocumentReference(
        userId: userId,
        reviewId: reviewId,
      ).delete();
}
