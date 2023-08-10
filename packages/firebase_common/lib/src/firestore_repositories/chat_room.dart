import '../firestore_documents/chat_room.dart';

class ChatRoomRepository {
  final _query = ChatRoomQuery();

  /// 指定した [ChatRoom] を取得する。
  Future<ReadChatRoom?> fetchChatRoom({required String chatRoomId}) =>
      _query.fetchDocument(chatRoomId: chatRoomId);

  /// 指定した [workerId] に一致するチャットルーム一覧を、更新日の降順で購読する。
  Stream<List<ReadChatRoom>> subscribeChatRoomsOfWorker({
    required String workerId,
  }) =>
      _query.subscribeDocuments(
        queryBuilder: (query) => query
            .where('workerId', isEqualTo: workerId)
            .orderBy('updatedAt', descending: true),
      );

  /// 指定した [hostId] に一致するチャットルーム一覧を、更新日の降順で購読する。
  Stream<List<ReadChatRoom>> subscribeChatRoomsOfHost({
    required String hostId,
  }) =>
      _query.subscribeDocuments(
        queryBuilder: (query) => query
            .where('hostId', isEqualTo: hostId)
            .orderBy('updatedAt', descending: true),
      );
}
