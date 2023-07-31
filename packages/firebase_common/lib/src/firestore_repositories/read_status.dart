import '../firestore_documents/read_status.dart';

class ReadStatusRepository {
  final _query = ReadStatusQuery();

  /// 指定したチャットルーム ([chatRoomId])、ユーザー ID ([userId]) の [ReadStatus]
  /// を現在のサーバ時刻で更新する。
  Future<void> updateLastReadAt({
    required String chatRoomId,
    required String userId,
  }) =>
      _query.set(
        chatRoomId: chatRoomId,
        readStatusId: userId,
        createReadStatus: const CreateReadStatus(),
      );
}
