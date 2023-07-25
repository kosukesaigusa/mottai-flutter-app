import '../firestore_documents/chat_room.dart';

class ChatRoomRepository {
  final _query = ChatRoomQuery();

  /// 指定した [ChatRoom] を取得する。
  Future<ReadChatRoom?> fetchChatRoom({required String chatRoomId}) =>
      _query.fetchDocument(chatRoomId: chatRoomId);
}
