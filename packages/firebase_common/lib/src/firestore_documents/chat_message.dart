import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

part 'chat_message.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'chatRooms/{chatRoomId}/chatMessages',
  documentName: 'chatMessage',
)
class ChatMessage {
  ChatMessage({
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

  @ReadDefault('')
  final String content;

  final List<String> imageUrls;

  final bool isDeleted;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @sealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  final SealedTimestamp createdAt;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @alwaysUseServerTimestampSealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  @UpdateDefault(ServerTimestamp())
  final SealedTimestamp updatedAt;
}

enum MessageType {
  worker,
  host,
  system,
  ;
}
