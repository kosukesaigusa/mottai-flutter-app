import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/chat_message.dart';

class ChatMessageRepository {
  final _query = ChatMessageQuery();

  /// [loadMessagesWithDocumentIdCursor] メソッドにおいて、最後に読み込んだ
  /// [QueryDocumentSnapshot] を保持するための [Map] 型の変数。
  /// キーはそのドキュメント ID で、バリューが [QueryDocumentSnapshot].
  final Map<String, QueryDocumentSnapshot<ReadChatMessage>>
      _lastReadQueryDocumentSnapshotCache = {};

  /// 指定したチャットルームのメッセージの、指定した [lastReadChatMessageId] に
  /// 対応する [QueryDocumentSnapshot] 以降のメッセージを [limit] 件だけ取得する。
  /// Dart 3 以降の [Record] を用いて、取得した [ReadChatMessage] 一覧に加え、
  /// 最後に取得したドキュメント ID ([lastReadChatMessageId]) も返す。
  /// 返り値の [lastReadChatMessageId] が `null` の場合は、これ以上読み取る
  /// ドキュメントが存在していないことを表している。
  Future<(List<ReadChatMessage>, String?, bool)>
      loadMessagesWithDocumentIdCursor({
    required String chatRoomId,
    required int limit,
    required String? lastReadChatMessageId,
  }) async {
    var query = readChatMessageCollectionReference(chatRoomId: chatRoomId)
        .orderBy('createdAt', descending: true);
    final qds = lastReadChatMessageId == null
        ? null
        : _lastReadQueryDocumentSnapshotCache[lastReadChatMessageId];
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    final qs = await query.limit(limit).get();
    final readChatMessages = qs.docs.map((qds) => qds.data()).toList();
    final lastReadQds = qs.docs.lastOrNull;
    _updateLastReadQueryDocumentSnapshotCache(lastReadQds);
    return (
      readChatMessages,
      lastReadQds?.id,
      readChatMessages.length >= limit,
    );
  }

  /// まず [_lastReadQueryDocumentSnapshotCache] をクリアして、非 null の場合は、
  /// 新しい [lastReadQueryDocumentSnapshot] をキャッシュに入れる。
  void _updateLastReadQueryDocumentSnapshotCache(
    QueryDocumentSnapshot<ReadChatMessage>? lastReadQueryDocumentSnapshot,
  ) {
    _lastReadQueryDocumentSnapshotCache.clear();
    if (lastReadQueryDocumentSnapshot != null) {
      _lastReadQueryDocumentSnapshotCache[lastReadQueryDocumentSnapshot.id] =
          lastReadQueryDocumentSnapshot;
    }
  }

  /// 指定した [chatRoomId] の、[startDateTime] 以降の [ChatMessage] 一覧を購読
  /// する。
  Stream<List<ReadChatMessage>> subscribeChatMessages({
    required String chatRoomId,
    required DateTime startDateTime,
  }) =>
      _query.subscribeDocuments(
        chatRoomId: chatRoomId,
        queryBuilder: (q) => q
            .orderBy('createdAt', descending: true)
            .where('createdAt', isGreaterThanOrEqualTo: startDateTime),
      );

  /// 指定した [chatRoomId] に [ChatMessage] を作成する。
  Future<void> addChatMessage({
    required String chatRoomId,
    required String senderId,
    required ChatMessageType chatMessageType,
    required String content,
    List<String> imageUrls = const <String>[],
  }) =>
      _query.add(
        chatRoomId: chatRoomId,
        createChatMessage: CreateChatMessage(
          senderId: senderId,
          chatMessageType: chatMessageType,
          content: content,
          imageUrls: imageUrls,
        ),
      );

  /// 指定した [chatRoomId] の [ChatMessage] 一覧の最新を最大 1 件返す。
  Stream<List<ReadChatMessage>> subscribeLatestChatMessages({
    required String chatRoomId,
  }) =>
      _query.subscribeDocuments(
        chatRoomId: chatRoomId,
        queryBuilder: (query) => query
            .where('isDeleted', isNotEqualTo: true)
            .orderBy('isDeleted')
            .orderBy('createdAt', descending: true)
            .limit(1),
      );

  /// 指定した [chatRoomId] の（指定している場合は）[lastReadAt] 以降の [ChatMessage]
  /// を最大 [limit] 件購読する。
  Stream<List<ReadChatMessage>> subscribeUnReadChatMessages({
    required String chatRoomId,
    required DateTime? lastReadAt,
    required int limit,
  }) =>
      _query.subscribeDocuments(
        chatRoomId: chatRoomId,
        queryBuilder: (query) => lastReadAt != null
            ? query
                .where(
                  'createdAt',
                  isGreaterThan: lastReadAt,
                )
                .orderBy('createdAt', descending: true)
                .limit(limit)
            : query.orderBy('createAt', descending: true).limit(limit),
      );
}
