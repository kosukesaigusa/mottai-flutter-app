// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

class ReadChatMessage {
  const ReadChatMessage({
    required this.chatMessageId,
    required this.path,
    required this.senderId,
    required this.chatMessageType,
    required this.content,
    required this.imageUrls,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String chatMessageId;

  final String path;

  final String senderId;

  final ChatMessageType chatMessageType;

  final String content;

  final List<String> imageUrls;

  final bool isDeleted;

  final SealedTimestamp createdAt;

  final SealedTimestamp updatedAt;

  factory ReadChatMessage._fromJson(Map<String, dynamic> json) {
    return ReadChatMessage(
      chatMessageId: json['chatMessageId'] as String,
      path: json['path'] as String,
      senderId: json['senderId'] as String,
      chatMessageType:
          _chatMessageTypeConverter.fromJson(json['chatMessageType'] as String),
      content: json['content'] as String? ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadChatMessage.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadChatMessage._fromJson(<String, dynamic>{
      ...data,
      'chatMessageId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateChatMessage {
  const CreateChatMessage({
    required this.senderId,
    required this.chatMessageType,
    required this.content,
    this.imageUrls = const <String>[],
    this.isDeleted = false,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String senderId;
  final ChatMessageType chatMessageType;
  final String content;
  final List<String> imageUrls;
  final bool isDeleted;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'chatMessageType': _chatMessageTypeConverter.toJson(chatMessageType),
      'content': content,
      'imageUrls': imageUrls,
      'isDeleted': isDeleted,
      'createdAt': sealedTimestampConverter.toJson(createdAt),
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateChatMessage {
  const UpdateChatMessage({
    this.senderId,
    this.chatMessageType,
    this.content,
    this.imageUrls,
    this.isDeleted,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? senderId;
  final ChatMessageType? chatMessageType;
  final String? content;
  final List<String>? imageUrls;
  final bool? isDeleted;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (senderId != null) 'senderId': senderId,
      if (chatMessageType != null)
        'chatMessageType': _chatMessageTypeConverter.toJson(chatMessageType!),
      if (content != null) 'content': content,
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (isDeleted != null) 'isDeleted': isDeleted,
      if (createdAt != null)
        'createdAt': sealedTimestampConverter.toJson(createdAt!),
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to chatMessages collection to read.
CollectionReference<ReadChatMessage> readChatMessageCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chatMessages')
        .withConverter<ReadChatMessage>(
          fromFirestore: (ds, _) => ReadChatMessage.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => throw UnimplementedError(),
        );

/// A [DocumentReference] to chatMessage document to read.
DocumentReference<ReadChatMessage> readChatMessageDocumentReference({
  required String chatRoomId,
  required String chatMessageId,
}) =>
    readChatMessageCollectionReference(chatRoomId: chatRoomId)
        .doc(chatMessageId);

/// A [CollectionReference] to chatMessages collection to create.
CollectionReference<CreateChatMessage> createChatMessageCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chatMessages')
        .withConverter<CreateChatMessage>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to chatMessage document to create.
DocumentReference<CreateChatMessage> createChatMessageDocumentReference({
  required String chatRoomId,
  required String chatMessageId,
}) =>
    createChatMessageCollectionReference(chatRoomId: chatRoomId)
        .doc(chatMessageId);

/// A [CollectionReference] to chatMessages collection to update.
CollectionReference<UpdateChatMessage> updateChatMessageCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chatMessages')
        .withConverter<UpdateChatMessage>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to chatMessage document to update.
DocumentReference<UpdateChatMessage> updateChatMessageDocumentReference({
  required String chatRoomId,
  required String chatMessageId,
}) =>
    updateChatMessageCollectionReference(chatRoomId: chatRoomId)
        .doc(chatMessageId);

/// A [CollectionReference] to chatMessages collection to delete.
CollectionReference<Object?> deleteChatMessageCollectionReference({
  required String chatRoomId,
}) =>
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chatMessages');

/// A [DocumentReference] to chatMessage document to delete.
DocumentReference<Object?> deleteChatMessageDocumentReference({
  required String chatRoomId,
  required String chatMessageId,
}) =>
    deleteChatMessageCollectionReference(chatRoomId: chatRoomId)
        .doc(chatMessageId);

/// A query manager to execute query against [ChatMessage].
class ChatMessageQuery {
  /// Fetches [ReadChatMessage] documents.
  Future<List<ReadChatMessage>> fetchDocuments({
    required String chatRoomId,
    GetOptions? options,
    Query<ReadChatMessage>? Function(Query<ReadChatMessage> query)?
        queryBuilder,
    int Function(ReadChatMessage lhs, ReadChatMessage rhs)? compare,
  }) async {
    Query<ReadChatMessage> query =
        readChatMessageCollectionReference(chatRoomId: chatRoomId);
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

  /// Subscribes [ChatMessage] documents.
  Stream<List<ReadChatMessage>> subscribeDocuments({
    required String chatRoomId,
    Query<ReadChatMessage>? Function(Query<ReadChatMessage> query)?
        queryBuilder,
    int Function(ReadChatMessage lhs, ReadChatMessage rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadChatMessage> query =
        readChatMessageCollectionReference(chatRoomId: chatRoomId);
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

  /// Fetches a specified [ReadChatMessage] document.
  Future<ReadChatMessage?> fetchDocument({
    required String chatRoomId,
    required String chatMessageId,
    GetOptions? options,
  }) async {
    final ds = await readChatMessageDocumentReference(
      chatRoomId: chatRoomId,
      chatMessageId: chatMessageId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [ChatMessage] document.
  Stream<ReadChatMessage?> subscribeDocument({
    required String chatRoomId,
    required String chatMessageId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readChatMessageDocumentReference(
      chatRoomId: chatRoomId,
      chatMessageId: chatMessageId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [ChatMessage] document.
  Future<DocumentReference<CreateChatMessage>> add({
    required String chatRoomId,
    required CreateChatMessage createChatMessage,
  }) =>
      createChatMessageCollectionReference(chatRoomId: chatRoomId)
          .add(createChatMessage);

  /// Sets a [ChatMessage] document.
  Future<void> set({
    required String chatRoomId,
    required String chatMessageId,
    required CreateChatMessage createChatMessage,
    SetOptions? options,
  }) =>
      createChatMessageDocumentReference(
        chatRoomId: chatRoomId,
        chatMessageId: chatMessageId,
      ).set(createChatMessage, options);

  /// Updates a specified [ChatMessage] document.
  Future<void> update({
    required String chatRoomId,
    required String chatMessageId,
    required UpdateChatMessage updateChatMessage,
  }) =>
      updateChatMessageDocumentReference(
        chatRoomId: chatRoomId,
        chatMessageId: chatMessageId,
      ).update(updateChatMessage.toJson());

  /// Deletes a specified [ChatMessage] document.
  Future<void> delete({
    required String chatRoomId,
    required String chatMessageId,
  }) =>
      deleteChatMessageDocumentReference(
        chatRoomId: chatRoomId,
        chatMessageId: chatMessageId,
      ).delete();
}
