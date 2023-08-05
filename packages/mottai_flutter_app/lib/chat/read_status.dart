import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../user/user_mode.dart';

/// チャット相手が最後に読んだ日時を取得する [Provider].
final chatPartnerLastReadAtProvider =
    Provider.family.autoDispose<DateTime?, ReadChatRoom>((ref, readChatRoom) {
  final readStatus =
      ref.watch(_chatPartnerReadStatusStreamProvider(readChatRoom)).valueOrNull;
  return readStatus?.lastReadAt.dateTime;
});

/// チャット相手の [ReadStatus] を購読する [StreamProvider].
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

  /// 指定したチャットルーム ([chatRoomId])、ユーザー ID ([userId]) の [ReadStatus]
  /// を取得する。
  Stream<ReadReadStatus?> subscribeReadStatus({
    required String chatRoomId,
    required String userId,
  }) =>
      _readStatusRepository.subscribeReadStatus(
        chatRoomId: chatRoomId,
        userId: userId,
      );

  /// [ReadStatus] を作成する.
  Future<void> createReadStatus({
    required String chatRoomId,
    required String userId,
  }) =>
      _readStatusRepository.setLastReadAt(
        chatRoomId: chatRoomId,
        userId: userId,
      );
}
