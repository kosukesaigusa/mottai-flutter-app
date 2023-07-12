// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_status.dart';

class ReadReadStatus {
  const ReadReadStatus._({
    required this.readStatusId,
    required this.readStatusReference,
    required this.userId,
    required this.lastReadAt,
  });

  final String readStatusId;
  final DocumentReference<ReadReadStatus> readStatusReference;
  final String userId;
  final SealedTimestamp lastReadAt;

  factory ReadReadStatus._fromJson(Map<String, dynamic> json) {
    return ReadReadStatus._(
      readStatusId: json['readStatusId'] as String,
      readStatusReference:
          json['readStatusReference'] as DocumentReference<ReadReadStatus>,
      userId: json['userId'] as String,
      lastReadAt: json['lastReadAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['lastReadAt'] as Object),
    );
  }

  factory ReadReadStatus.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadReadStatus._fromJson(<String, dynamic>{
      ...data,
      'readStatusId': ds.id,
      'readStatusReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadReadStatus.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadReadStatus copyWith({
    String? readStatusId,
    DocumentReference<ReadReadStatus>? readStatusReference,
    String? userId,
    SealedTimestamp? lastReadAt,
  }) {
    return ReadReadStatus._(
      readStatusId: readStatusId ?? this.readStatusId,
      readStatusReference: readStatusReference ?? this.readStatusReference,
      userId: userId ?? this.userId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}

class CreateReadStatus {
  const CreateReadStatus({
    required this.userId,
    this.lastReadAt = const ServerTimestamp(),
  });

  final String userId;
  final SealedTimestamp lastReadAt;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lastReadAt': sealedTimestampConverter.toJson(lastReadAt),
    };
  }
}

class UpdateReadStatus {
  const UpdateReadStatus({
    this.userId,
    this.lastReadAt = const ServerTimestamp(),
  });

  final String? userId;
  final SealedTimestamp? lastReadAt;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'lastReadAt': lastReadAt == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.toJson(lastReadAt!),
    };
  }
}

/// A [CollectionReference] to readStatuses collection to read.
CollectionReference<ReadReadStatus> readReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<ReadReadStatus>(
          fromFirestore: (ds, _) => ReadReadStatus.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => throw UnimplementedError(),
        );

/// A [DocumentReference] to readStatus document to read.
DocumentReference<ReadReadStatus> readReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    readReadStatusCollectionReference(chatRoomId: chatRoomId).doc(readStatusId);

/// A [CollectionReference] to readStatuses collection to create.
CollectionReference<CreateReadStatus> createReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<CreateReadStatus>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to readStatus document to create.
DocumentReference<CreateReadStatus> createReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    createReadStatusCollectionReference(chatRoomId: chatRoomId)
        .doc(readStatusId);

/// A [CollectionReference] to readStatuses collection to update.
CollectionReference<UpdateReadStatus> updateReadStatusCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('readStatuses')
        .withConverter<UpdateReadStatus>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to readStatus document to update.
DocumentReference<UpdateReadStatus> updateReadStatusDocumentReference({
  required String chatRoomId,
  required String readStatusId,
}) =>
    updateReadStatusCollectionReference(chatRoomId: chatRoomId)
        .doc(readStatusId);

/// A query manager to execute query against [ReadStatus].
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

  /// Fetches a specified [ReadReadStatus] document.
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

  /// Subscribes a specified [ReadStatus] document.
  Future<Stream<ReadReadStatus?>> subscribeDocument({
    required String chatRoomId,
    required String readStatusId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readReadStatusDocumentReference(
      chatRoomId: chatRoomId,
      readStatusId: readStatusId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Creates a [ReadStatus] document.
  Future<DocumentReference<CreateReadStatus>> create({
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

  /// Updates a specified [ReadStatus] document.
  Future<void> update({
    required String chatRoomId,
    required String readStatusId,
    required UpdateReadStatus updateReadStatus,
  }) =>
      updateReadStatusDocumentReference(
        chatRoomId: chatRoomId,
        readStatusId: readStatusId,
      ).update(updateReadStatus.toJson());
}
