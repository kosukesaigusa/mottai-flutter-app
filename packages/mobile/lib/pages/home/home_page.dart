import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/second/second_page.dart';
import 'package:mottai_flutter_app/route/utils.dart';
import 'package:mottai_flutter_app/services/firebase_messaging_service.dart';

/// バックグラウンドから起動した際にFirebaseを有効化する。
/// グローバルに記述する必要がある
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('バックグラウンドで通知を受信');
  await Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const path = '/';
  static const name = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    // 必要な初期化処理を行う
    Future.wait([
      _initializePushNotification(),
    ]);
  }

  /// アプリのライフサイクルを監視する
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('==========================================');
      print('AppLifecycleState: resumed');
      print('==========================================');
    } else if (state == AppLifecycleState.paused) {
      print('==========================================');
      print('AppLifecycleState: paused');
      print('==========================================');
    } else if (state == AppLifecycleState.detached) {
      print('==========================================');
      print('AppLifecycleState: detached');
      print('==========================================');
    } else if (state == AppLifecycleState.inactive) {
      print('==========================================');
      print('AppLifecycleState: inactive');
      print('==========================================');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Home'),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed<void>(
                  context,
                  SecondPage.path,
                  arguments: RouteArguments(<String, dynamic>{'title': '2 番目のページ'}),
                );
              },
              child: const Text('Go to SecondPage'),
            ),
          ],
        ),
      ),
    );
  }

  /// プッシュ通知関係の初期化処理を行う
  Future<void> _initializePushNotification() async {
    await FirebaseMessagingService.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// terminated（background ではない）の状態から
    /// 通知によってアプリを開いた場合に remoteMessage が非 null となる。
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      if (remoteMessage.data.containsKey('path')) {
        // 通知を元にページ遷移する
        await _navigateByNotification(
          path: remoteMessage.data['path'] as String,
          data: remoteMessage.data,
        );
      }
    }

    /// background（terminated ではない）の状態から
    /// 通知によてアプリを開いた場合に発火する。
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async {
      if (remoteMessage.data.containsKey('path')) {
        await _navigateByNotification(
          path: remoteMessage.data['path'] as String,
          data: remoteMessage.data,
        );
      }
    });
  }

  /// 通知によって遷移する
  Future<void> _navigateByNotification({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await Navigator.pushNamed(context, path, arguments: RouteArguments(data));
  }
}
