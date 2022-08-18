import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/auth/auth.dart';
import '../../utils/exceptions/common.dart';
import 'room.dart';

/// 指定した roomId の自身の readStatus ドキュメント：
/// rooms/{roomId}/readStatus/{userId} を購読する StreamProvider。
final readStatusProvider = StreamProvider.autoDispose.family<ReadStatus?, String>((ref, roomId) {
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
final partnerReadStatusProvider =
    StreamProvider.autoDispose.family<ReadStatus?, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  final room = ref.watch(roomProvider(roomId)).value;
  if (room == null) {
    throw Exception('指定したルームが見つかりませんでした。');
  }
  final partnerId = [room.workerId, room.hostId].firstWhere((id) => id != userId);
  return ref
      .read(messageRepositoryProvider)
      .subscribeReadStatus(roomId: roomId, readStatusId: partnerId);
});
