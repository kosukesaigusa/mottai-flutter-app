import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'logger.dart';
import 'navigation.dart';
import 'settings.dart';

/// FCM の Payload に含まれる、通知タップ時に画面遷移を期待している時のキー名。
const fcmPayloadLocationKey = 'location';

/// FirebaseMessaging のインスタンスを提供するプロバイダ。ProviderScope.override で上書きする。
final firebaseMessagingProvider = Provider<FirebaseMessaging>((_) => throw UnimplementedError());

/// iOS のフォアグラウンドでの通知受信の設定を済ませて FirebaseMessaging のインスタンスを返す。
/// ProviderScope.overrides で上書きする際に使用する。
Future<FirebaseMessaging> get getFirebaseMessagingInstance async {
  final messaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    // Push 通知をフォアグラウンドでも受け取るよう設定する。
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  return messaging;
}

/// FirebaseMessaging 関係の初期化処理を行うメソッドを提供する Provider。
final initializeFirebaseMessagingProvider = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    await ref.read(firebaseMessagingProvider).requestPermission();
    await ref.read(_initializeLocalNotificationProvider)();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await ref.read(_getInitialMessageProvider)();
    ref.read(_onMessageProvider)();
    ref.read(_onMessageOpenedAppProvider)();
  },
);

/// FCM トークンを取得する Provider。
final getFcmTokenProvider = Provider.autoDispose<Future<String?> Function()>(
  (ref) => () => ref.read(firebaseMessagingProvider).getToken(),
);

/// terminated (!= background) の状態から、通知によってアプリを開いた場合に非 null となる
/// RemoteMessage による挙動を提供する Provider。
final _getInitialMessageProvider = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    /// terminated (!= background) の状態から
    /// 通知によってアプリを開いた場合に remoteMessage が非 null となる。
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      logger.info('🔥 Open app from FCM when terminated.');
      final data = remoteMessage.data;
      await ref.read(_handleNotificationDataProvider)(data);
    }
  },
);

/// foreground の状態で通知が届いたときの RemoteMessage を提供する StreamProvider。
final _onMessageStreamProvider = StreamProvider<RemoteMessage>(
  (ref) => FirebaseMessaging.onMessage,
);

/// Android で foreground 時に通知が届いた場合の挙動を提供する Provider。
/// iOS では何もしない。
final _onMessageProvider = Provider(
  (ref) => () => ref.listen<AsyncValue<RemoteMessage>>(
        _onMessageStreamProvider,
        (previous, next) async {
          final remoteMessage = next.value;
          final androidNotification = remoteMessage?.notification?.android;
          if (remoteMessage == null || androidNotification == null) {
            return;
          }
          await _showLocalNotification(remoteMessage);
        },
      ),
);

/// Android 向け。
/// FCM の RemoteMessage を受け付けて、LocalNotification で通知を表示する。
Future<void> _showLocalNotification(RemoteMessage remoteMessage) async {
  final remoteNotification = remoteMessage.notification;
  if (remoteNotification == null) {
    return;
  }
  final title = remoteNotification.title ?? 'SPAJAM 2022';
  final body = remoteNotification.body ?? '新着通知があります。';
  await flutterLocalNotificationsPlugin.show(
    remoteNotification.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        channelDescription: androidNotificationChannel.description,
        importance: androidNotificationChannel.importance,
        priority: Priority.max,
        ticker: 'ticker',
        visibility: NotificationVisibility.public,
      ),
    ),
    payload: json.encode(remoteMessage.data),
  );
}

/// foreground or background (!= terminated) の状態で通知が届いたときの
/// RemoteMessage を提供する StreamProvider。
final _onMessageOpenedAppStreamProvider = StreamProvider<RemoteMessage>(
  (ref) => FirebaseMessaging.onMessageOpenedApp,
);

/// foreground or background (!= terminated) の状態から通知によってアプリを開いた場合の
/// 挙動を提供する Provider。
final _onMessageOpenedAppProvider = Provider(
  (ref) => () => ref.listen<AsyncValue<RemoteMessage>>(
        _onMessageOpenedAppStreamProvider,
        (previous, next) async {
          final remoteMessage = next.value;
          if (remoteMessage == null) {
            return;
          }
          if (remoteMessage.data.containsKey(fcmPayloadLocationKey)) {
            logger.info('🔥 FCM notification tapped.');
            final data = remoteMessage.data;
            await ref.read(_handleNotificationDataProvider)(data);
          }
        },
      ),
);

/// background から起動した際に Firebase を有効化する。
/// グローバルに記述する必要がある。
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage _) async {
  logger.info('Received remote message on background.');
  // 初期が完了している場合は初期化をスキップする。
  if (Firebase.apps.isNotEmpty && Platform.isAndroid) {
    return;
  }
  await Firebase.initializeApp();
}

/// グローバルな FlutterLocalNotificationsPlugin インスタンス。
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// グローバルな AndroidNotificationChannel インスタンス。
const androidNotificationChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'お知らせ',
  description: 'アプリ内からのお知らせを通知します。',
  importance: Importance.max,
);

/// Android で foreground で通知を受け取ったとき、通知を表示するための初期設定。
/// iOS では LocalNotification は使用しない想定。
final _initializeLocalNotificationProvider = Provider.autoDispose(
  (ref) => () async {
    // iOS では何もしない。
    if (Platform.isIOS) {
      return;
    }
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings(flavor.androidForegroundNotificationIcon),
        // iOS の場合は上で早期 return しているので、iOS の設定は記述しない。
      ),
      onSelectNotification: (payloadString) async {
        if (payloadString == null) {
          return;
        }
        logger.info('🔥 onSelect FCM notification when foreground on Android.');
        final data = jsonDecode(payloadString) as Map<String, dynamic>;
        await ref.read(_handleNotificationDataProvider)(data);
      },
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  },
);

/// Map<String, dynamic> 型の通知から得られるデータから location や data を取り出して
/// 画面遷移する共通処理を提供する Provider。
final _handleNotificationDataProvider =
    Provider.autoDispose<Future<void> Function(Map<String, dynamic>)>(
  (ref) => (data) async {
    final location = data[fcmPayloadLocationKey] as String;
    logger.info('***\nlocation: $location, data: $data\n***');
    if (data.containsKey(fcmPayloadLocationKey)) {
      await ref
          .read(navigationServiceProvider)
          .pushOnCurrentTab(location: location, arguments: data);
    }
  },
);
