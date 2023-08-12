// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_status.dart';

class ReadReadStatus {
  const ReadReadStatus({
    required this.readStatusId,
    required this.path,
    required this.lastReadAt,
  });

  final String readStatusId;

  final String path;

  final DateTime? lastReadAt;

  factory ReadReadStatus._fromJson(Map<String, dynamic> json) {
    return ReadReadStatus(
      readStatusId: json['readStatusId'] as String,
      path: json['path'] as String,
      lastReadAt: (json['lastReadAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadReadStatus.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadReadStatus._fromJson(<String, dynamic>{
      ...data,
      'readStatusId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateReadStatus {
  const CreateReadStatus();

  Map<String, dynamic> toJson() {
    return {
      'lastReadAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateReadStatus {
  const UpdateReadStatus();

  Map<String, dynamic> toJson() {
    return {
      'lastReadAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteReadStatus {}

/// Provides a reference to the readStatuses collection for reading.
CollectionReference<ReadReadStatus> readReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<ReadReadStatus>(
          fromFirestore: (ds, _) => ReadReadStatus.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a readStatus document for reading.
DocumentReference<ReadReadStatus> readReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    readReadStatusCollectionReference(chatRoomId: chatRoomId).doc(readStatusId);

/// Provides a reference to the readStatuses collection for creating.
CollectionReference<CreateReadStatus> createReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<CreateReadStatus>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a readStatus document for creating.
DocumentReference<CreateReadStatus> createReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    createReadStatusCollectionReference(chatRoomId: chatRoomId)
        .doc(readStatusId);

/// Provides a reference to the readStatuses collection for updating.
CollectionReference<UpdateReadStatus> updateReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<UpdateReadStatus>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a readStatus document for updating.
DocumentReference<UpdateReadStatus> updateReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    updateReadStatusCollectionReference(chatRoomId: chatRoomId)
        .doc(readStatusId);

/// Provides a reference to the readStatuses collection for deleting.
CollectionReference<DeleteReadStatus> deleteReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<DeleteReadStatus>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a readStatus document for deleting.
DocumentReference<DeleteReadStatus> deleteReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    deleteReadStatusCollectionReference(chatRoomId: chatRoomId)
        .doc(readStatusId);

/// Manages queries against the readStatuses collection.
class ReadStatusQuery {
  /// Fetches [ReadReadStatus] documents.
  Future<List<ReadReadStatus>> fetchDocuments({
    required String chatRoomId,
    GetOptions? options,
    Query<ReadReadStatus>? Function(Query<ReadReadStatus> query)? queryBuilder,
    int Function(ReadReadStatus lhs, ReadReadStatus rhs)? compare,
  }) async {
    Query<ReadReadStatus> query =
        readReadStatusCollectionReference(chatRoomId: chatRoomId);
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

  /// Subscribes [ReadStatus] documents.
  Stream<List<ReadReadStatus>> subscribeDocuments({
    required String chatRoomId,
    Query<ReadReadStatus>? Function(Query<ReadReadStatus> query)? queryBuilder,
    int Function(ReadReadStatus lhs, ReadReadStatus rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadReadStatus> query =
        readReadStatusCollectionReference(chatRoomId: chatRoomId);
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

  /// Fetches a specific [ReadReadStatus] document.
  Future<ReadReadStatus?> fetchDocument({
    required String chatRoomId,
    required String readStatusId,
    GetOptions? options,
  }) async {
    final ds = await readReadStatusDocumentReference(
      chatRoomId: chatRoomId,
      readStatusId: readStatusId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [ReadStatus] document.
  Stream<ReadReadStatus?> subscribeDocument({
    required String chatRoomId,
    required String readStatusId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readReadStatusDocumentReference(
      chatRoomId: chatRoomId,
      readStatusId: readStatusId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [ReadStatus] document.
  Future<DocumentReference<CreateReadStatus>> add({
    required String chatRoomId,
    required CreateReadStatus createReadStatus,
  }) =>
      createReadStatusCollectionReference(chatRoomId: chatRoomId)
          .add(createReadStatus);

  /// Sets a [ReadStatus] document.
  Future<void> set({
    required String chatRoomId,
    required String readStatusId,
    required CreateReadStatus createReadStatus,
    SetOptions? options,
  }) =>
      createReadStatusDocumentReference(
        chatRoomId: chatRoomId,
        readStatusId: readStatusId,
      ).set(createReadStatus, options);

  /// Updates a specific [ReadStatus] document.
  Future<void> update({
    required String chatRoomId,
    required String readStatusId,
    required UpdateReadStatus updateReadStatus,
  }) =>
      updateReadStatusDocumentReference(
        chatRoomId: chatRoomId,
        readStatusId: readStatusId,
      ).update(updateReadStatus.toJson());

  /// Deletes a specific [ReadStatus] document.
  Future<void> delete({
    required String chatRoomId,
    required String readStatusId,
  }) =>
      deleteReadStatusDocumentReference(
        chatRoomId: chatRoomId,
        readStatusId: readStatusId,
      ).delete();
}
