import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../user/user_mode.dart';



final chatPartnerLastReadAtProvider =
    Provider.family.autoDispose<DateTime?, ReadChatRoom>((ref, readChatRoom) {
  final readStatus =
      ref.watch(chatPartnerReadStatusStreamProvider(readChatRoom)).valueOrNull;
  return readStatus?.lastReadAt.dateTime;
});


final chatPartnerReadStatusStreamProvider =
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

/// 指定した[ReadStatus] の最終既読時間を返す [Provider]
/// 最終既読時間を読み込みできなかった場合は

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
