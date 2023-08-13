import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'chat_room.flutterfire_gen.dart';

@FirestoreDocument(path: 'chatRooms', documentName: 'chatRoom')
class ChatRoom {
  const ChatRoom({
    required this.workerId,
    required this.hostId,
    this.createdAt,
    this.updatedAt,
  });

  final String workerId;

  final String hostId;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
