// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

class ReadChatRoom {
  const ReadChatRoom._({
    required this.chatRoomId,
    required this.chatRoomReference,
    required this.workerId,
    required this.hostId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String chatRoomId;
  final DocumentReference<ReadChatRoom> chatRoomReference;
  final String workerId;
  final String hostId;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  factory ReadChatRoom._fromJson(Map<String, dynamic> json) {
    return ReadChatRoom._(
      chatRoomId: json['chatRoomId'] as String,
      chatRoomReference:
          json['chatRoomReference'] as DocumentReference<ReadChatRoom>,
      workerId: json['workerId'] as String,
      hostId: json['hostId'] as String,
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadChatRoom.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadChatRoom._fromJson(<String, dynamic>{
      ...data,
      'chatRoomId': ds.id,
      'chatRoomReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadChatRoom.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadChatRoom copyWith({
    String? chatRoomId,
    DocumentReference<ReadChatRoom>? chatRoomReference,
    String? workerId,
    String? hostId,
    SealedTimestamp? createdAt,
    SealedTimestamp? updatedAt,
  }) {
    return ReadChatRoom._(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      chatRoomReference: chatRoomReference ?? this.chatRoomReference,
      workerId: workerId ?? this.workerId,
      hostId: hostId ?? this.hostId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateChatRoom {
  const CreateChatRoom({
    required this.workerId,
    required this.hostId,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String workerId;
  final String hostId;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'hostId': hostId,
      'createdAt': sealedTimestampConverter.toJson(createdAt),
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateChatRoom {
  const UpdateChatRoom({
    this.workerId,
    this.hostId,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? workerId;
  final String? hostId;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (workerId != null) 'workerId': workerId,
      if (hostId != null) 'hostId': hostId,
      if (createdAt != null)
        'createdAt': sealedTimestampConverter.toJson(createdAt!),
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to chatRooms collection to read.
final readChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<ReadChatRoom>(
      fromFirestore: (ds, _) => ReadChatRoom.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to chatRoom document to read.
DocumentReference<ReadChatRoom> readChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    readChatRoomCollectionReference.doc(chatRoomId);

/// A [CollectionReference] to chatRooms collection to create.
final createChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<CreateChatRoom>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to chatRoom document to create.
DocumentReference<CreateChatRoom> createChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    createChatRoomCollectionReference.doc(chatRoomId);

/// A [CollectionReference] to chatRooms collection to update.
final updateChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<UpdateChatRoom>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to chatRoom document to update.
DocumentReference<UpdateChatRoom> updateChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    updateChatRoomCollectionReference.doc(chatRoomId);

/// A [CollectionReference] to chatRooms collection to delete.
final deleteChatRoomCollectionReference =
    FirebaseFirestore.instance.collection('chatRooms');

/// A [DocumentReference] to chatRoom document to delete.
DocumentReference<Object?> deleteChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    deleteChatRoomCollectionReference.doc(chatRoomId);

/// A query manager to execute query against [ChatRoom].
class ChatRoomQuery {
  /// Fetches [ReadChatRoom] documents.
  Future<List<ReadChatRoom>> fetchDocuments({
    GetOptions? options,
    Query<ReadChatRoom>? Function(Query<ReadChatRoom> query)? queryBuilder,
    int Function(ReadChatRoom lhs, ReadChatRoom rhs)? compare,
  }) async {
    Query<ReadChatRoom> query = readChatRoomCollectionReference;
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

  /// Subscribes [ChatRoom] documents.
  Stream<List<ReadChatRoom>> subscribeDocuments({
    Query<ReadChatRoom>? Function(Query<ReadChatRoom> query)? queryBuilder,
    int Function(ReadChatRoom lhs, ReadChatRoom rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadChatRoom> query = readChatRoomCollectionReference;
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

  /// Fetches a specified [ReadChatRoom] document.
  Future<ReadChatRoom?> fetchDocument({
    required String chatRoomId,
    GetOptions? options,
  }) async {
    final ds = await readChatRoomDocumentReference(
      chatRoomId: chatRoomId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [ChatRoom] document.
  Future<Stream<ReadChatRoom?>> subscribeDocument({
    required String chatRoomId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readChatRoomDocumentReference(
      chatRoomId: chatRoomId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [ChatRoom] document.
  Future<DocumentReference<CreateChatRoom>> add({
    required CreateChatRoom createChatRoom,
  }) =>
      createChatRoomCollectionReference.add(createChatRoom);

  /// Sets a [ChatRoom] document.
  Future<void> set({
    required String chatRoomId,
    required CreateChatRoom createChatRoom,
    SetOptions? options,
  }) =>
      createChatRoomDocumentReference(
        chatRoomId: chatRoomId,
      ).set(createChatRoom, options);

  /// Updates a specified [ChatRoom] document.
  Future<void> update({
    required String chatRoomId,
    required UpdateChatRoom updateChatRoom,
  }) =>
      updateChatRoomDocumentReference(
        chatRoomId: chatRoomId,
      ).update(updateChatRoom.toJson());

  /// Deletes a specified [ChatRoom] document.
  Future<void> delete({
    required String chatRoomId,
  }) =>
      deleteChatRoomDocumentReference(
        chatRoomId: chatRoomId,
      ).delete();
}
