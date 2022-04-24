import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// iOS のフォアグラウンドでの通知受信の設定を済ませて
/// FirebaseMessaging のインスタンスを返す。
/// ProviderScope の overrides で使用して fcmProvider.value を上書きする。
Future<FirebaseMessaging> get getFirebaseMessagingInstance async {
  final _messaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    // Push 通知をフォアグラウンドでも受け取るよう設定する。
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  return _messaging;
}

/// FirebaseMessaging のインスタンスを提供するプロバイダ。
/// ProviderScope の overrides で使用する。
final fcmProvider = Provider<FirebaseMessaging>((_) => throw UnimplementedError());

/// FirebaseMessaging の各機能を提供するプロバイダ。
final fcmServiceProvider =
    Provider<FirebaseMessagingService>((ref) => FirebaseMessagingService(ref.read));

class FirebaseMessagingService {
  FirebaseMessagingService(this._read);
  final Reader _read;

  /// Push 通知の許可を取る
  Future<void> requestPermission() async {
    try {
      await _read(fcmProvider).requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } on Exception {
      return;
    }
  }

  /// FCM トークンを取得する
  Future<String?> get getToken => _read(fcmProvider).getToken();
}
