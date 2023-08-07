import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FCM の Payload に含まれる、通知タップ時に画面遷移を期待している時のキー名。
const _fcmPayloadLocationKey = 'location';

/// FirebaseMessaging のインスタンスを提供するプロバイダ。ProviderScope.override で上書きする。
final firebaseMessagingProvider =
    Provider<FirebaseMessaging>((_) => throw UnimplementedError());

/// iOS のフォアグラウンドでの通知受信の設定を済ませて [FirebaseMessaging] のインスタンスを
/// 返す。
/// ProviderScope.overrides で上書きする際に使用する。
Future<FirebaseMessaging> getFirebaseMessagingInstance() async {
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

/// [FirebaseMessaging] 関係の初期化処理を行うメソッドを提供する [Provider].
final initializeFirebaseMessagingProvider =
    Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    await ref.read(firebaseMessagingProvider).requestPermission();
    await ref.read(_initializeLocalNotificationProvider)();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await ref.read(_getInitialMessageProvider)();
    ref.read(_onMessageProvider)();
    ref.read(_onMessageOpenedAppProvider)();
  },
);

/// FCM トークンを取得する [Provider].
final getFcmTokenProvider = Provider.autoDispose<Future<String?> Function()>(
  (ref) => () async {
    final token = await ref.read(firebaseMessagingProvider).getToken();
    if (token == null) {
      return null;
    }
    debugPrint('🔥 FCM token: $token');
    return token;
  },
);

/// terminated (!= background) の状態から、通知によってアプリを開いた場合に非 null となる
/// [RemoteMessage] による挙動を提供する [Provider].
final _getInitialMessageProvider =
    Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    /// terminated (!= background) の状態から
    /// 通知によってアプリを開いた場合に remoteMessage が非 null となる。
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      debugPrint('🔥 Open app from FCM when terminated.');
      final data = remoteMessage.data;
      await ref.read(_handleNotificationDataProvider)(data);
    }
  },
);

/// foreground の状態で通知が届いたときの [RemoteMessage] を提供する [StreamProvider].
final _onMessageStreamProvider = StreamProvider<RemoteMessage>(
  (ref) => FirebaseMessaging.onMessage,
);

/// Android で foreground 時に通知が届いた場合の挙動を提供する [Provider].
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

/// Android におけるローカル通知のデフォルトのタイトル。
const _androidLocalNotificationDefaultTitle = 'NPO 法人 MOTTAI';

/// Android におけるローカル通知のデフォルトの本文。
const _androidLocalNotificationDefaultBody = '新着通知があります。';

/// Android 向け。
/// FCM の [RemoteMessage] を受け付けて、[FlutterLocalNotificationsPlugin] で通知を
/// 表示する。
Future<void> _showLocalNotification(RemoteMessage remoteMessage) async {
  final remoteNotification = remoteMessage.notification;
  if (remoteNotification == null) {
    return;
  }
  final title =
      remoteNotification.title ?? _androidLocalNotificationDefaultTitle;
  final body = remoteNotification.body ?? _androidLocalNotificationDefaultBody;
  await _flutterLocalNotificationsPlugin.show(
    remoteNotification.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        _androidLocalNotificationChannel.id,
        _androidLocalNotificationChannel.name,
        channelDescription: _androidLocalNotificationChannel.description,
        importance: _androidLocalNotificationChannel.importance,
        priority: Priority.max,
        ticker: 'ticker',
        visibility: NotificationVisibility.public,
      ),
    ),
    payload: json.encode(remoteMessage.data),
  );
}

/// foreground or background (!= terminated) の状態で通知が届いたときの
/// [RemoteMessage] を提供する [StreamProvider].
final _onMessageOpenedAppStreamProvider = StreamProvider<RemoteMessage>(
  (ref) => FirebaseMessaging.onMessageOpenedApp,
);

/// foreground or background (!= terminated) の状態から通知によってアプリを開いた場合の
/// 挙動を提供する [Provider].
final _onMessageOpenedAppProvider = Provider(
  (ref) => () => ref.listen<AsyncValue<RemoteMessage>>(
        _onMessageOpenedAppStreamProvider,
        (previous, next) async {
          final remoteMessage = next.value;
          if (remoteMessage == null) {
            return;
          }
          if (remoteMessage.data.containsKey(_fcmPayloadLocationKey)) {
            debugPrint('🔥 FCM notification tapped.');
            final data = remoteMessage.data;
            await ref.read(_handleNotificationDataProvider)(data);
          }
        },
      ),
);

/// background から起動した際に Firebase を有効化する。
/// グローバルに記述する必要がある。
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage _) async {
  debugPrint('Received remote message on background.');
  // 初期が完了している場合は初期化をスキップする。
  if (Firebase.apps.isNotEmpty && Platform.isAndroid) {
    return;
  }
  await Firebase.initializeApp();
}

/// [FlutterLocalNotificationsPlugin] インスタンス。
final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Android におけるローカル通知のチャンネル ID.
const _androidLocalNotificationChannelId = 'high_importance_channel';

/// Android におけるローカル通知のチャンネル名。
const _androidLocalNotificationChannelName = 'お知らせ';

/// Android におけるローカル通知のチャンネルの説明。
const _androidLocalNotificationChannelDescription = 'アプリ内からのお知らせを通知します。';

/// Android におけるローカル通知のチャンネルの重要度。
const _androidLocalNotificationChannelImportance = Importance.max;

/// [AndroidNotificationChannel] インスタンス。
const _androidLocalNotificationChannel = AndroidNotificationChannel(
  _androidLocalNotificationChannelId,
  _androidLocalNotificationChannelName,
  description: _androidLocalNotificationChannelDescription,
  importance: _androidLocalNotificationChannelImportance,
);

/// Android におけるローカル通知のデフォルトのアイコン。
// TODO: アイコン自体は過去の適当なアイコンからもってきた。適切なアイコンに変更する。
const _androidLocalNotificationDefaultIcon =
    '@drawable/transparent_notification_icon';

/// Android で foreground で通知を受け取ったとき、通知を表示するための初期設定。
/// iOS では LocalNotification は使用しない想定。
final _initializeLocalNotificationProvider = Provider.autoDispose(
  (ref) => () async {
    // iOS では何もしない。
    if (Platform.isIOS) {
      return;
    }
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          _androidLocalNotificationDefaultIcon,
        ),
        // iOS の場合は上で早期 return しているので、iOS の設定は記述しない。
      ),
      onDidReceiveNotificationResponse: (notificationResponse) async {
        final payloadString = notificationResponse.payload;
        if (payloadString == null) {
          return;
        }
        debugPrint('🔥 onSelect FCM notification when foreground on Android.');
        final data = jsonDecode(payloadString) as Map<String, dynamic>;
        await ref.read(_handleNotificationDataProvider)(data);
      },
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidLocalNotificationChannel);
  },
);

/// Map<String, dynamic> 型の通知から得られるデータから location や data を取り出して
/// 画面遷移する共通処理を提供する Provider。
final _handleNotificationDataProvider =
    Provider.autoDispose<Future<void> Function(Map<String, dynamic>)>(
  (ref) => (data) async {
    final location = data[_fcmPayloadLocationKey] as String;
    debugPrint(location);
    if (data.containsKey(_fcmPayloadLocationKey)) {
      // TODO: 適切な画面遷移の Callback を外から指定できるようにする。
      // // location: `/` の場合は、すべての画面を取り除く
      // if (location == ref.read(appRouterProvider).initialRoute) {
      //   ref.read(navigationServiceProvider).popUntilFirstRoute();
      // } else {
      //   await ref
      //       .read(navigationServiceProvider)
      //       .pushOnCurrentTab(location: location, arguments: data);
      // }
    }
  },
);
