// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_inappropriate_report.dart';

class ReadUserInappropriateReport {
  const ReadUserInappropriateReport({
    required this.userInappropriateReportId,
    required this.path,
    required this.userId,
    required this.targetId,
    required this.inappropriateContentReportedType,
    required this.createdAt,
  });

  final String userInappropriateReportId;

  final String path;

  final String userId;

  final String targetId;

  final InappropriateContentReportedType inappropriateContentReportedType;

  final DateTime? createdAt;

  factory ReadUserInappropriateReport._fromJson(Map<String, dynamic> json) {
    return ReadUserInappropriateReport(
      userInappropriateReportId: json['userInappropriateReportId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      targetId: json['targetId'] as String,
      inappropriateContentReportedType:
          _inappropriateContentReportedTypesConverter
              .fromJson(json['inappropriateContentReportedType'] as String),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadUserInappropriateReport.fromDocumentSnapshot(
      DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUserInappropriateReport._fromJson(<String, dynamic>{
      ...data,
      'userInappropriateReportId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUserInappropriateReport {
  const CreateUserInappropriateReport({
    required this.userId,
    required this.targetId,
    required this.inappropriateContentReportedType,
  });

  final String userId;
  final String targetId;
  final InappropriateContentReportedType inappropriateContentReportedType;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'targetId': targetId,
      'inappropriateContentReportedType':
          _inappropriateContentReportedTypesConverter
              .toJson(inappropriateContentReportedType),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateUserInappropriateReport {
  const UpdateUserInappropriateReport({
    this.userId,
    this.targetId,
    this.inappropriateContentReportedType,
    this.createdAt,
  });

  final String? userId;
  final String? targetId;
  final InappropriateContentReportedType? inappropriateContentReportedType;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (targetId != null) 'targetId': targetId,
      if (inappropriateContentReportedType != null)
        'inappropriateContentReportedType':
            _inappropriateContentReportedTypesConverter
                .toJson(inappropriateContentReportedType!),
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class DeleteUserInappropriateReport {}

/// Provides a reference to the userInappropriateReport collection for reading.
final readUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReport')
    .withConverter<ReadUserInappropriateReport>(
      fromFirestore: (ds, _) =>
          ReadUserInappropriateReport.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userInappropriateReport document for reading.
DocumentReference<ReadUserInappropriateReport>
    readUserInappropriateReportDocumentReference({
  required String userInappropriateReportId,
}) =>
        readUserInappropriateReportCollectionReference
            .doc(userInappropriateReportId);

/// Provides a reference to the userInappropriateReport collection for creating.
final createUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReport')
    .withConverter<CreateUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userInappropriateReport document for creating.
DocumentReference<CreateUserInappropriateReport>
    createUserInappropriateReportDocumentReference({
  required String userInappropriateReportId,
}) =>
        createUserInappropriateReportCollectionReference
            .doc(userInappropriateReportId);

/// Provides a reference to the userInappropriateReport collection for updating.
final updateUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReport')
    .withConverter<UpdateUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userInappropriateReport document for updating.
DocumentReference<UpdateUserInappropriateReport>
    updateUserInappropriateReportDocumentReference({
  required String userInappropriateReportId,
}) =>
        updateUserInappropriateReportCollectionReference
            .doc(userInappropriateReportId);

/// Provides a reference to the userInappropriateReport collection for deleting.
final deleteUserInappropriateReportCollectionReference = FirebaseFirestore
    .instance
    .collection('userInappropriateReport')
    .withConverter<DeleteUserInappropriateReport>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userInappropriateReport document for deleting.
DocumentReference<DeleteUserInappropriateReport>
    deleteUserInappropriateReportDocumentReference({
  required String userInappropriateReportId,
}) =>
        deleteUserInappropriateReportCollectionReference
            .doc(userInappropriateReportId);

/// Manages queries against the userInappropriateReport collection.
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
    required String userInappropriateReportId,
    GetOptions? options,
  }) async {
    final ds = await readUserInappropriateReportDocumentReference(
      userInappropriateReportId: userInappropriateReportId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [UserInappropriateReport] document.
  Stream<ReadUserInappropriateReport?> subscribeDocument({
    required String userInappropriateReportId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUserInappropriateReportDocumentReference(
      userInappropriateReportId: userInappropriateReportId,
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
    required String userInappropriateReportId,
    required CreateUserInappropriateReport createUserInappropriateReport,
    SetOptions? options,
  }) =>
      createUserInappropriateReportDocumentReference(
        userInappropriateReportId: userInappropriateReportId,
      ).set(createUserInappropriateReport, options);

  /// Updates a specific [UserInappropriateReport] document.
  Future<void> update({
    required String userInappropriateReportId,
    required UpdateUserInappropriateReport updateUserInappropriateReport,
  }) =>
      updateUserInappropriateReportDocumentReference(
        userInappropriateReportId: userInappropriateReportId,
      ).update(updateUserInappropriateReport.toJson());

  /// Deletes a specific [UserInappropriateReport] document.
  Future<void> delete({
    required String userInappropriateReportId,
  }) =>
      deleteUserInappropriateReportDocumentReference(
        userInappropriateReportId: userInappropriateReportId,
      ).delete();
}
