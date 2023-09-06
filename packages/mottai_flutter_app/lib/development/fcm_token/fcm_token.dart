import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import '../../push_notification/firebase_messaging.dart';

/// 指定した [UserFcmToken] を取得する [FutureProvider].
final fcmTokenFutureProvider = FutureProvider.family
    .autoDispose<ReadUserFcmToken?, String>((ref, userFcmTokenId) async {
  return ref
      .watch(fcmTokenRepositoryProvider)
      .fetchUserFcmToken(userFcmTokenId: userFcmTokenId);
});

/// [ref]を渡して、登録してある[UserFcmToken] を取得する。
Future<ReadUserFcmToken?> getUserDeviceInfo(WidgetRef ref) async {
  final token = await ref.read(getFcmTokenProvider).call();
  if (token == null) {
    return null;
  }
  final userDeviceInfo = await ref.read(fcmTokenFutureProvider(token).future);
  if (userDeviceInfo == null) {
    return null;
  }

  return userDeviceInfo;
}
