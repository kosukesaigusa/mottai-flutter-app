import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../firestore_repository.dart';
import '../../push_notification/firebase_messaging.dart';
import '../../root/ui/root.dart';

final fcmTokenServiceProvider = Provider.autoDispose<FcmTokenService>(
  (ref) => FcmTokenService(
    fcmTokenRepository: ref.watch(fcmTokenRepositoryProvider),
  ),
);

/// [ref]を渡して、登録してある[UserFcmToken] を取得する。
Future<ReadUserFcmToken?> getUserDeviceInfo(WidgetRef ref) async {
  final token = await ref.read(getFcmTokenProvider).call();
  if (token == null) {
    return null;
  }
  final userDeviceInfo = await ref.read(fcmTokenServiceProvider).fetchFcmToken(
        userFcmTokenId: token,
      );
  if (userDeviceInfo == null) {
    return null;
  }

  return userDeviceInfo;
}

/// [ref]を渡して、[UserFcmToken] を登録する。
Future<void> setFcmTokenWithDeviceInfo(WidgetRef ref) async {
  final token = await ref.read(getFcmTokenProvider).call();
  final userId = ref.read(userIdProvider);
  final deviceInfo = await getDeviceInfo();

  if (token == null || userId == null) {
    return;
  }

  await ref.read(fcmTokenServiceProvider).setFcmToken(
        userId: userId,
        token: token,
        deviceInfo: deviceInfo,
      );
}

class FcmTokenService {
  const FcmTokenService({required FcmTokenRepository fcmTokenRepository})
      : _fcmRepositoryRepository = fcmTokenRepository;

  final FcmTokenRepository _fcmRepositoryRepository;

  /// 指定した [userId], [token]、[deviceInfo]をもとに ユーザーのFCMトークン情報を作成する。
  Future<void> setFcmToken({
    required String userId,
    required String token,
    required String deviceInfo,
  }) =>
      _fcmRepositoryRepository.set(
        userId: userId,
        token: token,
        deviceInfo: deviceInfo,
      );

  /// 指定した [userFcmTokenId]をもとに ユーザーのFCMトークン情報を取得する。
  Future<ReadUserFcmToken?> fetchFcmToken({
    required String userFcmTokenId,
  }) =>
      _fcmRepositoryRepository.fetchDocument(userFcmTokenId: userFcmTokenId);
}
