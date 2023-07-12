import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

import '../json_converters/message_type.dart';

part 'chat_message.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'chatRooms/{chatRoomId}/chatMessages',
  documentName: 'chatMessage',
)
class ChatMessage {
  ChatMessage({
    required this.senderId,
    required this.chatMessageType,
    required this.content,
    this.imageUrls = const <String>[],
    this.isDeleted = false,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String senderId;

  @chatMessageTypeConverter
  final ChatMessageType chatMessageType;

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

enum ChatMessageType {
  worker,
  host,
  system,
  ;

  /// 与えられた文字列に対応する [ChatMessageType] を返す。
  factory ChatMessageType.fromString(String messageTypeString) {
    switch (messageTypeString) {
      case 'worker':
        return ChatMessageType.worker;
      case 'host':
        return ChatMessageType.host;
      case 'system':
        return ChatMessageType.system;
    }
    throw ArgumentError('メッセージ種別が正しくありません。');
  }
}
