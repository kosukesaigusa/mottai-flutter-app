import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_controller.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_state.dart';
import 'package:mottai_flutter_app/route/main_tabs.dart';
import 'package:mottai_flutter_app/route/utils.dart';
import 'package:mottai_flutter_app/services/firebase_messaging_service.dart';
import 'package:mottai_flutter_app/widgets/main/stacked_pages_navigator.dart';
import 'package:provider/provider.dart';

/// バックグラウンドから起動した際にFirebaseを有効化する。
/// グローバルに記述する必要がある
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('バックグラウンドで通知を受信');
  await Firebase.initializeApp();
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const path = '/';
  static const name = 'MainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
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
      body: Stack(
        children: [
          Scaffold(
            body: Stack(
              children: [
                for (final item in bottomNavigationBarItems) _buildStackedPages(context, item),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: (index) {
                FocusScope.of(context).unfocus();
                context.read<BottomNavigationBarController>().changeTab(index);
              },
              currentIndex: context.watch<BottomNavigationBarState>().currentIndex,
              items: [
                for (final item in bottomNavigationBarItems)
                  BottomNavigationBarItem(
                    icon: Icon(item.iconData),
                    label: item.label,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _buildStackedPages(BuildContext context, BottomNavigationBarItemData item) {
    final currentIndex = context.select<BottomNavigationBarState, int>((s) => s.currentIndex);
    final currentItem = bottomNavigationBarItems[currentIndex];
    return Offstage(
      offstage: item != currentItem,
      child: TickerMode(
        enabled: item == currentItem,
        child: MainStackedPagesNavigator(item: item),
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
