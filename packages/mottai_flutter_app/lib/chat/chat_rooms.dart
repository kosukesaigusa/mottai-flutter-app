import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth.dart';
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

/// 指定した `chatRoomId` における自分の未読メッセージ数を最大 [_maxUnReadCount] + 1 件
/// 取得する [StreamProvider].
final _unReadCountStreamProvider =
    StreamProvider.autoDispose.family<int, ReadChatRoom>((ref, readChatRoom) {
  final readStatus = ref.watch(myReadStatusStreamProvider(readChatRoom)).value;
  final lastReadAt = readStatus?.lastReadAt;
  return ref
      .watch(chatMessageRepositoryProvider)
      .subscribeUnReadChatMessages(
        chatRoomId: readChatRoom.chatRoomId,
        lastReadAt: lastReadAt,
        limit: _maxUnReadCount + 1,
      )
      .map((messages) => messages.length);
});

/// 指定した `readChatRoom` における自分の未読メッセージ数を表す文字列を取得する [Provider].
/// [_unReadCountStreamProvider] で取得した未読メッセージ数を利用する。
/// 未読メッセージ数が 0 の場合は空文字列を返す。
/// 未読メッセージ数が [_maxUnReadCount] を超える場合は `${_maxUnReadCount}+` を返す。
final unReadCountStringProvider =
    Provider.autoDispose.family<String, ReadChatRoom>((ref, readChatRoom) {
  final unReadCount =
      ref.watch(_unReadCountStreamProvider(readChatRoom)).value ?? 0;
  if (unReadCount == 0) {
    return '';
  }
  if (unReadCount > _maxUnReadCount) {
    return '$_maxUnReadCount+';
  }
  return unReadCount.toString();
});

/// 指定した `partnerId` とサインイン中のユーザーとのチャットルームが存在するかどうかを取得する
/// [FutureProvider].
final chatRoomExistsProvider =
    Provider.family.autoDispose<bool, String>((ref, partnerId) {
  final myUserId = ref.watch(userIdProvider);
  if (myUserId == null) {
    return false;
  }
  final userMode = ref.watch(userModeStateProvider);
  switch (userMode) {
    case UserMode.worker:
      return ref
              .watch(_chatRoomExistsFutureProvider((myUserId, partnerId)))
              .valueOrNull ??
          false;
    case UserMode.host:
      return ref
              .watch(_chatRoomExistsFutureProvider((partnerId, myUserId)))
              .valueOrNull ??
          false;
  }
});

/// 指定した `workerId`, `hostId` とのチャットルームが存在するかどうかを取得する
/// [FutureProvider].
final _chatRoomExistsFutureProvider =
    FutureProvider.family.autoDispose<bool, (String, String)>(
  (ref, workerIdAndHostId) =>
      ref.watch(chatRoomRepositoryProvider).chatRoomExists(
            workerId: workerIdAndHostId.$1,
            hostId: workerIdAndHostId.$2,
          ),
);
