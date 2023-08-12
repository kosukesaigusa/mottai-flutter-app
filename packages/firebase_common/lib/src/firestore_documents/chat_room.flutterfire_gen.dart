// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

class ReadChatRoom {
  const ReadChatRoom({
    required this.chatRoomId,
    required this.path,
    required this.workerId,
    required this.hostId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String chatRoomId;

  final String path;

  final String workerId;

  final String hostId;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadChatRoom._fromJson(Map<String, dynamic> json) {
    return ReadChatRoom(
      chatRoomId: json['chatRoomId'] as String,
      path: json['path'] as String,
      workerId: json['workerId'] as String,
      hostId: json['hostId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadChatRoom.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadChatRoom._fromJson(<String, dynamic>{
      ...data,
      'chatRoomId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateChatRoom {
  const CreateChatRoom({
    required this.workerId,
    required this.hostId,
  });

  final String workerId;
  final String hostId;

  Map<String, dynamic> toJson() {
    return {
      'workerId': workerId,
      'hostId': hostId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateChatRoom {
  const UpdateChatRoom({
    this.workerId,
    this.hostId,
    this.createdAt,
  });

  final String? workerId;
  final String? hostId;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (workerId != null) 'workerId': workerId,
      if (hostId != null) 'hostId': hostId,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteChatRoom {}

/// Provides a reference to the chatRooms collection for reading.
final readChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<ReadChatRoom>(
      fromFirestore: (ds, _) => ReadChatRoom.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a chatRoom document for reading.
DocumentReference<ReadChatRoom> readChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    readChatRoomCollectionReference.doc(chatRoomId);

/// Provides a reference to the chatRooms collection for creating.
final createChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<CreateChatRoom>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a chatRoom document for creating.
DocumentReference<CreateChatRoom> createChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    createChatRoomCollectionReference.doc(chatRoomId);

/// Provides a reference to the chatRooms collection for updating.
final updateChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<UpdateChatRoom>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a chatRoom document for updating.
DocumentReference<UpdateChatRoom> updateChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    updateChatRoomCollectionReference.doc(chatRoomId);

/// Provides a reference to the chatRooms collection for deleting.
final deleteChatRoomCollectionReference = FirebaseFirestore.instance
    .collection('chatRooms')
    .withConverter<DeleteChatRoom>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a chatRoom document for deleting.
DocumentReference<DeleteChatRoom> deleteChatRoomDocumentReference({
  required String chatRoomId,
}) =>
    deleteChatRoomCollectionReference.doc(chatRoomId);

/// Manages queries against the chatRooms collection.
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

  /// Fetches a specific [ReadChatRoom] document.
  Future<ReadChatRoom?> fetchDocument({
    required String chatRoomId,
    GetOptions? options,
  }) async {
    final ds = await readChatRoomDocumentReference(
      chatRoomId: chatRoomId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [ChatRoom] document.
  Stream<ReadChatRoom?> subscribeDocument({
    required String chatRoomId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
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

  /// Updates a specific [ChatRoom] document.
  Future<void> update({
    required String chatRoomId,
    required UpdateChatRoom updateChatRoom,
  }) =>
      updateChatRoomDocumentReference(
        chatRoomId: chatRoomId,
      ).update(updateChatRoom.toJson());

  /// Deletes a specific [ChatRoom] document.
  Future<void> delete({
    required String chatRoomId,
  }) =>
      deleteChatRoomDocumentReference(
        chatRoomId: chatRoomId,
      ).delete();
}
