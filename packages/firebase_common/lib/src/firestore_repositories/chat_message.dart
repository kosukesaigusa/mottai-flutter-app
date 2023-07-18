import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/chat_message.dart';

class ChatMessageRepository {
  final _query = ChatMessageQuery();

  /// [loadMessagesWithDocumentIdCursor] メソッドにおいて、最後に読み込んだ
  /// [QueryDocumentSnapshot] を保持するための [Map] 型の変数。
  /// キーはそのドキュメント ID で、バリューが [QueryDocumentSnapshot].
  final Map<String, QueryDocumentSnapshot<ReadChatMessage>>
      _lastReadQueryDocumentSnapshotCache = {};

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

  /// 指定したチャットルームのメッセージの、指定した [lastReadChatMessageId] に
  /// 対応する [QueryDocumentSnapshot] 以降のメッセージを [limit] 件だけ取得する。
  /// Dart 3 以降の [Record] を用いて、取得した [ReadChatMessage] 一覧に加え、
  /// 最後に取得したドキュメント ID ([lastReadChatMessageId]) も返す。
  /// [lastReadChatMessageId] が `null` の場合は、これ以上読み取るドキュメントが
  /// 存在していないことを表している。
  Future<(List<ReadChatMessage>, String?)> loadMessagesWithDocumentIdCursor({
    required String chatRoomId,
    required int limit,
    required String lastReadChatMessageId,
  }) async {
    var query = readChatMessageCollectionReference(chatRoomId: chatRoomId)
        .orderBy('createdAt', descending: true);
    final qds = _lastReadQueryDocumentSnapshotCache[lastReadChatMessageId];
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    final qs = await query.limit(limit).get();
    final readChatMessages = qs.docs.map((qds) => qds.data()).toList();
    final lastReadQds = qs.docs.lastOrNull;
    _updateLastReadQueryDocumentSnapshotCache(lastReadQds);
    return (readChatMessages, lastReadQds?.id);
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
}
