import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../user/user_mode.dart';
import 'read_status.dart';

/// 自分のチャットルーム一覧画面に表示するべき [ChatRoom] 一覧を取得する
/// [StreamProvider].
final chatRoomsStreamProvider = StreamProvider.family
    .autoDispose<List<ReadChatRoom>, String>((ref, userId) {
  final userMode = ref.watch(userModeStateProvider);
  switch (userMode) {
    case UserMode.worker:
      return ref
          .watch(chatRoomRepositoryProvider)
          .subscribeChatRoomsOfWorker(workerId: userId);
    case UserMode.host:
      return ref
          .watch(chatRoomRepositoryProvider)
          .subscribeChatRoomsOfHost(hostId: userId);
  }
});

/// 指定した `chatRoomId` の最新メッセージ一覧を取得する [StreamProvider].
/// 得られる `List<ReadChatMessage>` には最大 1 件の [ChatMessage] が入っている。
final _latestMessageStreamProvider =
    StreamProvider.family.autoDispose<List<ReadChatMessage>, String>(
  (ref, chatRoomId) => ref
      .watch(chatMessageRepositoryProvider)
      .subscribeLatestChatMessages(chatRoomId: chatRoomId),
);

/// 指定した `chatRoomId` の最新メッセージを取得する [Provider].
/// `_latestMessageStreamProvider` で取得したメッセージを利用します。
final latestMessageProvider =
    Provider.family.autoDispose<ReadChatMessage?, String>((ref, chatRoomId) {
  final latestMessages =
      ref.watch(_latestMessageStreamProvider(chatRoomId)).value ?? [];
  return latestMessages.firstOrNull;
});

/// 未読メッセージ数の最大値。
const _maxUnReadCount = 10;

/// 指定した `chatRoomId` における自分の未読メッセージ数を最大 [_maxUnReadCount] 件取得
/// する [StreamProvider].
final _unReadCountStreamProvider =
    StreamProvider.autoDispose.family<int, ReadChatRoom>((ref, readChatRoom) {
  final readStatus = ref.watch(myReadStatusStreamProvider(readChatRoom)).value;
  final lastReadAt = readStatus?.lastReadAt.dateTime;
  return ref
      .watch(chatMessageRepositoryProvider)
      .subscribeUnReadChatMessages(
        chatRoomId: readChatRoom.chatRoomId,
        lastReadAt: lastReadAt,
        limit: _maxUnReadCount,
      )
      .map((messages) => messages.length);
});

/// 指定した `chatRoomId` の未読メッセージを取得する [Provider].
/// `_unReadCountStreamProvider` で取得した未読メッセージ数を利用します。
final unReadCountProvider =
    Provider.autoDispose.family<int, String>((ref, chatRoomId) {
  final unReadCount = ref.watch(_unReadCountStreamProvider(chatRoomId)).value;
  return unReadCount ?? 0;
});
