import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth_providers.dart';
import '../read_status/read_status_providers.dart';
import '../room/room_providers.dart';

/// ユーザーの attendingRoom コレクションを購読する StreamProvider
final attendingRoomsStreamProvider = StreamProvider.autoDispose<List<AttendingRoom>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return ref.read(messageRepositoryProvider).subscribeAttendingRooms(
        userId: userId,
        queryBuilder: (q) => q.orderBy('updatedAt', descending: true),
      );
});

/// 指定した roomId の messages サブコレクションに、指定した DateTime より
/// createdAt が未来の相手が送信した（送信者が自分ではない）
/// ドキュメントの個数（最大 10 個）を購読する StreamProvider
final unreadCountStreamProvider = StreamProvider.autoDispose.family<int, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  final room = ref.watch(roomStreamProvider(roomId)).value;
  if (room == null) {
    throw Exception('指定したルームが見つかりませんでした。');
  }
  final readStatus = ref.watch(readStatusStreamProvider(roomId)).value;
  final lastReadAt = readStatus?.lastReadAt;
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
