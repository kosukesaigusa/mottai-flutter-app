import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth_providers.dart';
import '../room/room_providers.dart';

/// 指定した roomId の rooms/{roomId}/readStatus/{自分の userId}
/// のドキュメントを購読する StreamProvider。
final readStatusStreamProvider =
    StreamProvider.autoDispose.family<ReadStatus?, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return ref.read(messageRepositoryProvider).subscribeReadStatus(
        roomId: roomId,
        readStatusId: userId,
        excludePendingWrites: true,
      );
});

/// 指定した roomId の相手が最後にメッセージ読んだ時間を購読する StreamProvider。
final partnerReadStatusStreamProvider =
    StreamProvider.autoDispose.family<ReadStatus?, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  final room = ref.watch(roomStreamProvider(roomId)).value;
  if (room == null) {
    throw Exception('指定したルームが見つかりませんでした。');
  }
  final partnerId = [room.workerId, room.hostId].firstWhere((id) => id != userId);
  return ref
      .read(messageRepositoryProvider)
      .subscribeReadStatus(roomId: roomId, readStatusId: partnerId);
});
