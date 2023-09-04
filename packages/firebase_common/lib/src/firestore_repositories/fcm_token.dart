import '../firestore_documents/user_fcm_token.dart';

class FcmTokenRepository {
  final _query = UserFcmTokenQuery();

  /// 指定した [userId], [token]、[deviceInfo]をもとに ユーザーのFCMトークン情報を作成する。
  Future<void> setUserFcmToken({
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

  /// 指定した [userFcmTokenId]をもとに ユーザーのFCMトークン情報を取得する。
  Future<ReadUserFcmToken?> fetchUserFcmToken({
    required String userFcmTokenId,
  }) =>
      _query.fetchDocument(userFcmTokenId: userFcmTokenId);
}
