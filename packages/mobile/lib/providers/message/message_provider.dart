import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/providers/room/room_provider.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth_providers.dart';

/// 指定した roomId の messages サブコレクションを購読する StreamProvider
final messagesStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return MessageRepository.subscribeMessages(
    roomId: roomId,
    queryBuilder: (q) => q.orderBy('createdAt', descending: true),
  );
});

/// 指定した roomId の messages サブコレクションに、指定した DateTime より
/// createdAt が未来の相手が送信した（送信者が自分ではない）
/// ドキュメントの個数（最大 9 個）を購読する StreamProvider
final unreadCountStreamProvider = StreamProvider.autoDispose.family<int, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  final room = ref.watch(roomStreamProvider(roomId)).value;
  if (room == null) {
    throw Exception('指定したルームが見つかりませんでした。');
  }
  final lastReadAt = room.lastReadAt[userId];
  if (lastReadAt == null) {
    return Stream.value(0);
  }
  return MessageRepository.subscribeMessages(
    roomId: room.roomId,
    queryBuilder: (q) => q
        .where('createdAt', isGreaterThan: lastReadAt)
        .orderBy('createdAt', descending: true)
        .limit(10),
  ).map((messages) => messages.where((message) => message.senderId != userId).toList().length);
});
