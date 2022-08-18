import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../utils/exceptions/common.dart';
import '../../utils/scaffold_messenger.dart';
import '../../utils/utils.dart';
import '../auth/auth.dart';
import 'read_status_providers.dart';
import 'room.dart';

/// 指定した roomId の messages サブコレクションの最新最大 1 件を購読する StreamProvider。
final _latestMessagesOfRoomProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return ref.read(messageRepositoryProvider).subscribeMessages(
        roomId: roomId,
        queryBuilder: (q) => q.orderBy('createdAt', descending: true).limit(1),
      );
});

/// 指定した roomId の messages サブコレクションの最新最大 1 件を返す Provider。
final latestMessageOfRoomProvider = Provider.autoDispose.family<Message?, String>((ref, roomId) {
  return ref.watch(_latestMessagesOfRoomProvider(roomId)).when(
        data: (messages) => messages.isNotEmpty ? messages.first : null,
        error: (_, __) => null,
        loading: () => null,
      );
});

/// ユーザーの attendingRoom コレクションを購読する StreamProvider。
/// ユーザーがログインしていない場合は例外をスローする。
final attendingRoomsProvider = StreamProvider.autoDispose<List<AttendingRoom>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  final attendingRooms = ref.read(messageRepositoryProvider).subscribeAttendingRooms(
        userId: userId,
        queryBuilder: (q) => q.orderBy('updatedAt', descending: true),
      );
  return attendingRooms;
});

/// 指定した roomId の messages サブコレクションに、message.createdAt が指定した DateTime より
/// 未来かつ送信者が相手である（自分ではない）ドキュメントの個数（最大 10 個）を購読する
/// StreamProvider。
final unreadCountProvider = StreamProvider.autoDispose.family<int, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(0);
  }
  final room = ref.watch(roomProvider(roomId)).value;
  if (room == null) {
    return Stream.value(0);
  }
  final readStatus = ref.watch(readStatusProvider(roomId)).value;
  final lastReadAt = readStatus?.lastReadAt.dateTime;
  return ref
      .read(messageRepositoryProvider)
      .subscribeMessages(
        roomId: room.roomId,
        queryBuilder: (q) => lastReadAt != null
            ? q
                .where('createdAt', isGreaterThan: lastReadAt)
                .orderBy('createdAt', descending: true)
                .limit(10)
            : q.orderBy('createdAt', descending: true).limit(10),
      )
      .map((messages) => messages.where((message) => message.senderId != userId).toList().length);
});

// TODO: 開発中のみ。後です。
/// HOST 1 とのチャットルームを作成する作成するメソッドを提供する Provider。
final createChatRoomWithHost1Provider = Provider.autoDispose(
  (ref) => () async {
    final userId = ref.watch(userIdProvider).value;
    if (userId == null) {
      return;
    }
    final roomId = uuid;
    const hostId = String.fromEnvironment('HOST_1_ID');
    await ref
        .read(messageRepositoryProvider)
        .roomRef(roomId: roomId)
        .set(Room(roomId: roomId, hostId: hostId, workerId: userId));
    await ref.read(messageRepositoryProvider).attendingRoomRef(userId: userId, roomId: roomId).set(
          AttendingRoom(
            roomId: roomId,
            partnerId: hostId,
          ),
        );
    ref.read(scaffoldMessengerServiceProvider).showSnackBar('【テスト用】ホスト 1 とのルームを作成しました。');
  },
);
