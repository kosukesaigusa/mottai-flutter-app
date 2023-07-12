// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

class ReadChatMessage {
  const ReadChatMessage._({
    required this.chatMessageId,
    required this.chatMessageReference,
    required this.senderId,
    required this.messageType,
    required this.content,
    required this.imageUrls,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String chatMessageId;
  final DocumentReference<ReadChatMessage> chatMessageReference;
  final String senderId;
  final MessageType messageType;
  final String content;
  final List<String> imageUrls;
  final bool isDeleted;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  factory ReadChatMessage._fromJson(Map<String, dynamic> json) {
    return ReadChatMessage._(
      chatMessageId: json['chatMessageId'] as String,
      chatMessageReference:
          json['chatMessageReference'] as DocumentReference<ReadChatMessage>,
      senderId: json['senderId'] as String,
      messageType: json['messageType'] as MessageType,
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
      'chatMessageReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadChatMessage.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadChatMessage copyWith({
    String? chatMessageId,
    DocumentReference<ReadChatMessage>? chatMessageReference,
    String? senderId,
    MessageType? messageType,
    String? content,
    List<String>? imageUrls,
    bool? isDeleted,
    SealedTimestamp? createdAt,
    SealedTimestamp? updatedAt,
  }) {
    return ReadChatMessage._(
      chatMessageId: chatMessageId ?? this.chatMessageId,
      chatMessageReference: chatMessageReference ?? this.chatMessageReference,
      senderId: senderId ?? this.senderId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateChatMessage {
  const CreateChatMessage({
    required this.senderId,
    required this.messageType,
    required this.content,
    this.imageUrls = const <String>[],
    this.isDeleted = false,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String senderId;
  final MessageType messageType;
  final String content;
  final List<String> imageUrls;
  final bool isDeleted;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'messageType': messageType,
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
    this.messageType,
    this.content,
    this.imageUrls,
    this.isDeleted,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? senderId;
  final MessageType? messageType;
  final String? content;
  final List<String>? imageUrls;
  final bool? isDeleted;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (senderId != null) 'senderId': senderId,
      if (messageType != null) 'messageType': messageType,
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
  Future<Stream<ReadChatMessage?>> subscribeDocument({
    required String chatRoomId,
    required String chatMessageId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readChatMessageDocumentReference(
      chatRoomId: chatRoomId,
      chatMessageId: chatMessageId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Creates a [ChatMessage] document.
  Future<DocumentReference<CreateChatMessage>> create({
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
}
