import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/chat_message.dart';

class ChatMessageRepository {
  final _query = ChatMessageQuery();

  /// 指定したチャットルームのメッセージの、指定した [lastReadQueryDocumentSnapshot]
  /// 以降のメッセージを [limit] 件だけ取得する。
  /// Dart 3 以降の [Record] を用いて、取得した [ReadChatMessage] 一覧に加え、
  /// 最後に取得した [QueryDocumentSnapshot] も返す。
  Future<(List<ReadChatMessage>, QueryDocumentSnapshot<ReadChatMessage>?)>
      loadMessagesWithCursor({
    required String chatRoomId,
    required int limit,
    required QueryDocumentSnapshot<ReadChatMessage>?
        lastReadQueryDocumentSnapshot,
  }) async {
    var query = readChatMessageCollectionReference(chatRoomId: chatRoomId)
        .orderBy('createdAt', descending: true);
    final qds = lastReadQueryDocumentSnapshot;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    final qs = await query.limit(limit).get();
    final readChatMessages = qs.docs.map((qds) => qds.data()).toList();
    return (readChatMessages, qs.docs.lastOrNull);
  }
}
