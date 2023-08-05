import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../user/user_mode.dart';

/// チャット相手の最後に読んだ時間を取得する [Provider].
final chatPartnerLastReadAtProvider =
    Provider.family.autoDispose<DateTime?, ReadChatRoom>((ref, readChatRoom) {
  final readStatus =
      ref.watch(_chatPartnerReadStatusStreamProvider(readChatRoom)).valueOrNull;
  return readStatus?.lastReadAt.dateTime;
});

/// チャット相手の [ReadStatus] を取得する [StreamProvider].
final _chatPartnerReadStatusStreamProvider =
    StreamProvider.family.autoDispose<ReadReadStatus?, ReadChatRoom>(
  (ref, readChatRoom) {
    final userMode = ref.watch(userModeStateProvider);
    switch (userMode) {
      case UserMode.worker:
        return ref.watch(readStatusRepositoryProvider).subscribeReadStatus(
              chatRoomId: readChatRoom.chatRoomId,
              userId: readChatRoom.hostId,
            );
      case UserMode.host:
        return ref.watch(readStatusRepositoryProvider).subscribeReadStatus(
              chatRoomId: readChatRoom.chatRoomId,
              userId: readChatRoom.workerId,
            );
    }
  },
);

final readStatusServiceProvider = Provider.autoDispose<ReadStatusService>(
  (ref) => ReadStatusService(
    readStatusRepository: ref.watch(readStatusRepositoryProvider),
  ),
);

class ReadStatusService {
  const ReadStatusService({required ReadStatusRepository readStatusRepository})
      : _readStatusRepository = readStatusRepository;

  final ReadStatusRepository _readStatusRepository;

  /// [ReadStatus] を更新する。
  Future<void> setReadStatus({
    required String chatRoomId,
    required String userId,
  }) =>
      _readStatusRepository.setLastReadAt(
        chatRoomId: chatRoomId,
        userId: userId,
      );
}
