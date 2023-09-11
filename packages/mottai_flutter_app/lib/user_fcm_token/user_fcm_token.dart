import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import '../device_info.dart';
import '../push_notification/firebase_messaging.dart';

/// 指定した `userId` の [UserFcmToken] 一覧を購読する [StreamProvider].
final userFcmTokensStreamProvider =
    StreamProvider.autoDispose.family<List<ReadUserFcmToken>, String>(
  (ref, userId) => ref
      .watch(userFcmTokenRepositoryProvider)
      .subscribeUserFcmToken(userId: userId),
);

final fcmTokenServiceProvider = Provider.autoDispose<FcmTokenService>(
  (ref) => FcmTokenService(
    getFcmToken: ref.watch(getFcmTokenProvider),
    deviceInfo: ref.watch(deviceInfoProvider),
    userFcmTokenRepository: ref.watch(userFcmTokenRepositoryProvider),
  ),
);

class FcmTokenService {
  const FcmTokenService({
    required Future<String?> Function() getFcmToken,
    required String deviceInfo,
    required UserFcmTokenRepository userFcmTokenRepository,
  })  : _getFcmToken = getFcmToken,
        _deviceInfo = deviceInfo,
        _userFcmTokenRepositoryRepository = userFcmTokenRepository;

  final Future<String?> Function() _getFcmToken;

  final String _deviceInfo;

  final UserFcmTokenRepository _userFcmTokenRepositoryRepository;

  /// 指定した [userId] の FCM トークンを保存する。
  Future<void> setUserFcmToken({required String userId}) async {
    final fcmToken = await _getFcmToken();
    if (fcmToken == null) {
      // 例外をスローするのも悪くないが、エラーハンドリングしてユーザーに通知するまでもないので
      // ここでは何もしない。
      return;
    }
    await _userFcmTokenRepositoryRepository.set(
      userId: userId,
      token: fcmToken,
      deviceInfo: _deviceInfo,
    );
  }
}
