import '../firestore_documents/user_fcm_token.dart';

class UserFcmTokenRepository {
  final _query = UserFcmTokenQuery();

  /// 指定した [userId] の FCM トークン ([token]) をデバイス情報 [deviceInfo] とともに
  /// 保存する。
  Future<void> set({
    required String userId,
    required String token,
    required String deviceInfo,
  }) =>
      _query.set(
        userFcmTokenId: token,
        createUserFcmToken: CreateUserFcmToken(
          userId: userId,
          token: token,
          deviceInfo: deviceInfo,
        ),
      );

  /// 指定した [userId] の FCM トークン一覧を購読する。
  Stream<List<ReadUserFcmToken>> subscribeUserFcmToken({
    required String userId,
  }) =>
      _query.subscribeDocuments(
        queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      );
}
