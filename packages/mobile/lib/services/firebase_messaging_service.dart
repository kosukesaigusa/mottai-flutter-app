import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

/// main.dart でのイニシャライズ処理と
/// MainPage でのイニシャライズ処理および通知受信時のハンドリングで使用するメソッドを
/// まとめたクラス。
/// Riverpod の Provider で提供するほどでもないのと、
/// ref が取れない main.dart のグローバルな関数内でこのクラスのメソッドを呼ぶ方法が分からないので
/// とりあえずシングルトンクラスで定義する。
class FirebaseMessagingService {
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();

  static final _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      /// Push通知をフォアグラウンドでも受け取る設定
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Push 通知の許可を取る
  static Future<void> requestPermission() async {
    try {
      await _messaging.requestPermission(
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
  static Future<String?> get getToken => _messaging.getToken();
}
