// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disable_user_account_request.dart';

class ReadDisableUserAccountRequests {
  const ReadDisableUserAccountRequests({
    required this.disableUserAccountRequestId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String disableUserAccountRequestId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadDisableUserAccountRequests._fromJson(Map<String, dynamic> json) {
    return ReadDisableUserAccountRequests(
      disableUserAccountRequestId:
          json['disableUserAccountRequestId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadDisableUserAccountRequests.fromDocumentSnapshot(
      DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadDisableUserAccountRequests._fromJson(<String, dynamic>{
      ...data,
      'disableUserAccountRequestId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateDisableUserAccountRequests {
  const CreateDisableUserAccountRequests({
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

class UpdateDisableUserAccountRequests {
  const UpdateDisableUserAccountRequests({
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

class DeleteDisableUserAccountRequests {}

/// Provides a reference to the disableUserAccountRequests collection for reading.
final readDisableUserAccountRequestsCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<ReadDisableUserAccountRequests>(
      fromFirestore: (ds, _) =>
          ReadDisableUserAccountRequests.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a disableUserAccountRequest document for reading.
DocumentReference<ReadDisableUserAccountRequests>
    readDisableUserAccountRequestsDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        readDisableUserAccountRequestsCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for creating.
final createDisableUserAccountRequestsCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<CreateDisableUserAccountRequests>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a disableUserAccountRequest document for creating.
DocumentReference<CreateDisableUserAccountRequests>
    createDisableUserAccountRequestsDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        createDisableUserAccountRequestsCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for updating.
final updateDisableUserAccountRequestsCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<UpdateDisableUserAccountRequests>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a disableUserAccountRequest document for updating.
DocumentReference<UpdateDisableUserAccountRequests>
    updateDisableUserAccountRequestsDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        updateDisableUserAccountRequestsCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for deleting.
final deleteDisableUserAccountRequestsCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<DeleteDisableUserAccountRequests>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a disableUserAccountRequest document for deleting.
DocumentReference<DeleteDisableUserAccountRequests>
    deleteDisableUserAccountRequestsDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        deleteDisableUserAccountRequestsCollectionReference
            .doc(disableUserAccountRequestId);

/// Manages queries against the disableUserAccountRequests collection.
class DisableUserAccountRequestsQuery {
  /// Fetches [ReadDisableUserAccountRequests] documents.
  Future<List<ReadDisableUserAccountRequests>> fetchDocuments({
    GetOptions? options,
    Query<ReadDisableUserAccountRequests>? Function(
            Query<ReadDisableUserAccountRequests> query)?
        queryBuilder,
    int Function(ReadDisableUserAccountRequests lhs,
            ReadDisableUserAccountRequests rhs)?
        compare,
  }) async {
    Query<ReadDisableUserAccountRequests> query =
        readDisableUserAccountRequestsCollectionReference;
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

  /// Subscribes [DisableUserAccountRequests] documents.
  Stream<List<ReadDisableUserAccountRequests>> subscribeDocuments({
    Query<ReadDisableUserAccountRequests>? Function(
            Query<ReadDisableUserAccountRequests> query)?
        queryBuilder,
    int Function(ReadDisableUserAccountRequests lhs,
            ReadDisableUserAccountRequests rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadDisableUserAccountRequests> query =
        readDisableUserAccountRequestsCollectionReference;
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

  /// Fetches a specific [ReadDisableUserAccountRequests] document.
  Future<ReadDisableUserAccountRequests?> fetchDocument({
    required String disableUserAccountRequestId,
    GetOptions? options,
  }) async {
    final ds = await readDisableUserAccountRequestsDocumentReference(
      disableUserAccountRequestId: disableUserAccountRequestId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [DisableUserAccountRequests] document.
  Stream<ReadDisableUserAccountRequests?> subscribeDocument({
    required String disableUserAccountRequestId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readDisableUserAccountRequestsDocumentReference(
      disableUserAccountRequestId: disableUserAccountRequestId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [DisableUserAccountRequests] document.
  Future<DocumentReference<CreateDisableUserAccountRequests>> add({
    required CreateDisableUserAccountRequests createDisableUserAccountRequests,
  }) =>
      createDisableUserAccountRequestsCollectionReference
          .add(createDisableUserAccountRequests);

  /// Sets a [DisableUserAccountRequests] document.
  Future<void> set({
    required String disableUserAccountRequestId,
    required CreateDisableUserAccountRequests createDisableUserAccountRequests,
    SetOptions? options,
  }) =>
      createDisableUserAccountRequestsDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).set(createDisableUserAccountRequests, options);

  /// Updates a specific [DisableUserAccountRequests] document.
  Future<void> update({
    required String disableUserAccountRequestId,
    required UpdateDisableUserAccountRequests updateDisableUserAccountRequests,
  }) =>
      updateDisableUserAccountRequestsDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).update(updateDisableUserAccountRequests.toJson());

  /// Deletes a specific [DisableUserAccountRequests] document.
  Future<void> delete({
    required String disableUserAccountRequestId,
  }) =>
      deleteDisableUserAccountRequestsDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).delete();
}
