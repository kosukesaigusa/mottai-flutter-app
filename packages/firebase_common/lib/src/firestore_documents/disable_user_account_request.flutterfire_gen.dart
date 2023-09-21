// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disable_user_account_request.dart';

class ReadDisableUserAccountRequest {
  const ReadDisableUserAccountRequest({
    required this.disableUserAccountRequestId,
    required this.path,
    required this.userId,
    required this.createdAt,
  });

  final String disableUserAccountRequestId;

  final String path;

  final String userId;

  final DateTime? createdAt;

  factory ReadDisableUserAccountRequest._fromJson(Map<String, dynamic> json) {
    return ReadDisableUserAccountRequest(
      disableUserAccountRequestId:
          json['disableUserAccountRequestId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadDisableUserAccountRequest.fromDocumentSnapshot(
      DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadDisableUserAccountRequest._fromJson(<String, dynamic>{
      ...data,
      'disableUserAccountRequestId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateDisableUserAccountRequest {
  const CreateDisableUserAccountRequest({
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

class UpdateDisableUserAccountRequest {
  const UpdateDisableUserAccountRequest({
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

class DeleteDisableUserAccountRequest {}

/// Provides a reference to the disableUserAccountRequests collection for reading.
final readDisableUserAccountRequestCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<ReadDisableUserAccountRequest>(
      fromFirestore: (ds, _) =>
          ReadDisableUserAccountRequest.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a disableUserAccountRequest document for reading.
DocumentReference<ReadDisableUserAccountRequest>
    readDisableUserAccountRequestDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        readDisableUserAccountRequestCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for creating.
final createDisableUserAccountRequestCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<CreateDisableUserAccountRequest>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a disableUserAccountRequest document for creating.
DocumentReference<CreateDisableUserAccountRequest>
    createDisableUserAccountRequestDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        createDisableUserAccountRequestCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for updating.
final updateDisableUserAccountRequestCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<UpdateDisableUserAccountRequest>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a disableUserAccountRequest document for updating.
DocumentReference<UpdateDisableUserAccountRequest>
    updateDisableUserAccountRequestDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        updateDisableUserAccountRequestCollectionReference
            .doc(disableUserAccountRequestId);

/// Provides a reference to the disableUserAccountRequests collection for deleting.
final deleteDisableUserAccountRequestCollectionReference = FirebaseFirestore
    .instance
    .collection('disableUserAccountRequests')
    .withConverter<DeleteDisableUserAccountRequest>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a disableUserAccountRequest document for deleting.
DocumentReference<DeleteDisableUserAccountRequest>
    deleteDisableUserAccountRequestDocumentReference({
  required String disableUserAccountRequestId,
}) =>
        deleteDisableUserAccountRequestCollectionReference
            .doc(disableUserAccountRequestId);

/// Manages queries against the disableUserAccountRequests collection.
class DisableUserAccountRequestQuery {
  /// Fetches [ReadDisableUserAccountRequest] documents.
  Future<List<ReadDisableUserAccountRequest>> fetchDocuments({
    GetOptions? options,
    Query<ReadDisableUserAccountRequest>? Function(
            Query<ReadDisableUserAccountRequest> query)?
        queryBuilder,
    int Function(ReadDisableUserAccountRequest lhs,
            ReadDisableUserAccountRequest rhs)?
        compare,
  }) async {
    Query<ReadDisableUserAccountRequest> query =
        readDisableUserAccountRequestCollectionReference;
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

  /// Subscribes [DisableUserAccountRequest] documents.
  Stream<List<ReadDisableUserAccountRequest>> subscribeDocuments({
    Query<ReadDisableUserAccountRequest>? Function(
            Query<ReadDisableUserAccountRequest> query)?
        queryBuilder,
    int Function(ReadDisableUserAccountRequest lhs,
            ReadDisableUserAccountRequest rhs)?
        compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadDisableUserAccountRequest> query =
        readDisableUserAccountRequestCollectionReference;
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

  /// Fetches a specific [ReadDisableUserAccountRequest] document.
  Future<ReadDisableUserAccountRequest?> fetchDocument({
    required String disableUserAccountRequestId,
    GetOptions? options,
  }) async {
    final ds = await readDisableUserAccountRequestDocumentReference(
      disableUserAccountRequestId: disableUserAccountRequestId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [DisableUserAccountRequest] document.
  Stream<ReadDisableUserAccountRequest?> subscribeDocument({
    required String disableUserAccountRequestId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readDisableUserAccountRequestDocumentReference(
      disableUserAccountRequestId: disableUserAccountRequestId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [DisableUserAccountRequest] document.
  Future<DocumentReference<CreateDisableUserAccountRequest>> add({
    required CreateDisableUserAccountRequest createDisableUserAccountRequest,
  }) =>
      createDisableUserAccountRequestCollectionReference
          .add(createDisableUserAccountRequest);

  /// Sets a [DisableUserAccountRequest] document.
  Future<void> set({
    required String disableUserAccountRequestId,
    required CreateDisableUserAccountRequest createDisableUserAccountRequest,
    SetOptions? options,
  }) =>
      createDisableUserAccountRequestDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).set(createDisableUserAccountRequest, options);

  /// Updates a specific [DisableUserAccountRequest] document.
  Future<void> update({
    required String disableUserAccountRequestId,
    required UpdateDisableUserAccountRequest updateDisableUserAccountRequest,
  }) =>
      updateDisableUserAccountRequestDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).update(updateDisableUserAccountRequest.toJson());

  /// Deletes a specific [DisableUserAccountRequest] document.
  Future<void> delete({
    required String disableUserAccountRequestId,
  }) =>
      deleteDisableUserAccountRequestDocumentReference(
        disableUserAccountRequestId: disableUserAccountRequestId,
      ).delete();
}
