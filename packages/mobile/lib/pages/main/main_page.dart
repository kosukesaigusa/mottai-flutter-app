import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../controllers/application/application_controller.dart';
import '../../controllers/bottom_navigation_bar/bottom_navigation_bar_controller.dart';
import '../../route/main_tabs.dart';
import '../../services/firebase_messaging_service.dart';
import '../../utils/navigation.dart';
import '../../utils/utils.dart';
import '../../widgets/main/stacked_pages_navigator.dart';

/// バックグラウンドから起動した際にFirebaseを有効化する。
/// グローバルに記述する必要がある
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('バックグラウンドで通知を受信');
  await Firebase.initializeApp();
}

class MainPage extends StatefulHookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  static const path = '/';
  static const name = 'MainPage';

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    // 必要な初期化処理を行う
    Future.wait([
      _initializePushNotification(),
      _initializeDynamicLinks(),
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
              children: [for (final tab in bottomTabs) _buildStackedPages(tab)],
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.primary,
              // BottomTab の画面を切り替える。
              // 現在表示している状態のタブをタップした場合は画面をすべて pop する。
              onTap: (index) {
                FocusScope.of(context).unfocus();
                final tab = bottomTabs[index].tab;
                final state = ref.watch(bottomNavigationBarController);
                final tabNavigatorKey =
                    ref.watch(applicationController.notifier).navigatorKeys[state.currentTab];
                if (tabNavigatorKey == null) {
                  return;
                }
                if (tab == state.currentTab) {
                  tabNavigatorKey.currentState!.popUntil((route) => route.isFirst);
                  return;
                }
                ref.read(bottomNavigationBarController.notifier).changeTab(index: index, tab: tab);
              },
              currentIndex: ref.watch(bottomNavigationBarController.select((c) => c.currentIndex)),
              items: [
                for (final item in bottomTabs)
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

  /// MainPage の BottomNavigationBar で切り替える 3 つの画面
  Widget _buildStackedPages(BottomTab tab) {
    final currentIndex = ref.watch(bottomNavigationBarController).currentIndex;
    final currentTab = bottomTabs[currentIndex];
    return Offstage(
      offstage: tab != currentTab,
      child: TickerMode(
        enabled: tab == currentTab,
        child: MainStackedPagesNavigator(tab: tab),
      ),
    );
  }

  /// プッシュ通知関係の初期化処理を行う
  Future<void> _initializePushNotification() async {
    await FirebaseMessagingService.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// terminated (!= background) の状態から
    /// 通知によってアプリを開いた場合に remoteMessage が非 null となる。
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      print('🔥 Open from FCM when app is terminated.');
      final path = remoteMessage.data['path'] as String;
      final data = remoteMessage.data;
      print('*****************************');
      print('path: $path');
      print('data: $data');
      print('*****************************');
      if (remoteMessage.data.containsKey('path')) {
        await ref.read(navigationController).pushOnCurrentTab(path: path, data: data);
      }
    }

    /// foreground or background (!= terminated) の状態から
    /// 通知によってアプリを開いた場合に発火する。
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async {
      print('🔥 FCM notification tapped.');
      if (remoteMessage.data.containsKey('path')) {
        final path = remoteMessage.data['path'] as String;
        final data = remoteMessage.data;
        print('*****************************');
        print('path: $path');
        print('data: $data');
        print('*****************************');
        await ref.read(navigationController).pushOnCurrentTab(path: path, data: data);
      }
    });
  }

  /// Firebase Dynamic Links 関係の初期化処理を行う
  Future<void> _initializeDynamicLinks() async {
    /// background (!= terminated) でリンクを踏んだ場合
    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) async {
        print('🔗 Open from Firebase Dynamic Links');
        final uri = pendingDynamicLinkData.link;
        final path = normalizePathString(uri.path);
        print('*****************************');
        print('dynamicLink.link.path: $path');
        print('*****************************');
        await ref.read(navigationController).pushOnCurrentTab(
          path: path,
          data: <String, dynamic>{},
        );
      },
    );

    /// terminated (!= background) の状態からリンクを踏んだ場合
    final pendingDynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
    if (pendingDynamicLinkData != null) {
      await ref.read(navigationController).navigateByDynamicLink(pendingDynamicLinkData.link);
      return;
    }
  }
}
