import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/application/application.dart';
import '../../providers/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../providers/navigation/navigation.dart';
import '../../route/main_tabs.dart';
import '../../services/firebase_messaging_service.dart';
import '../../widgets/main/stacked_pages_navigator.dart';

/// バックグラウンドから起動した際にFirebaseを有効化する。
/// グローバルに記述する必要がある
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('バックグラウンドで通知を受信');
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
      debugPrint('==========================================');
      debugPrint('AppLifecycleState: resumed');
      debugPrint('==========================================');
    } else if (state == AppLifecycleState.paused) {
      debugPrint('==========================================');
      debugPrint('AppLifecycleState: paused');
      debugPrint('==========================================');
    } else if (state == AppLifecycleState.detached) {
      debugPrint('==========================================');
      debugPrint('AppLifecycleState: detached');
      debugPrint('==========================================');
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('==========================================');
      debugPrint('AppLifecycleState: inactive');
      debugPrint('==========================================');
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
            bottomNavigationBar: KeyboardVisibilityProvider.isKeyboardVisible(context)
                ? null
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    // BottomTab の画面を切り替える。
                    // 現在表示している状態のタブをタップした場合は画面をすべて pop する。
                    onTap: (index) {
                      FocusScope.of(context).unfocus();
                      final tab = bottomTabs[index].tab;
                      final state = ref.watch(bottomNavigationBarStateNotifier);
                      final tabNavigatorKey = ref
                          .watch(applicationStateNotifier.notifier)
                          .bottomTabKeys[state.currentTab];
                      if (tabNavigatorKey == null) {
                        return;
                      }
                      if (tab == state.currentTab) {
                        tabNavigatorKey.currentState!.popUntil((route) => route.isFirst);
                        return;
                      }
                      ref
                          .read(bottomNavigationBarStateNotifier.notifier)
                          .changeTab(index: index, tab: tab);
                    },
                    currentIndex:
                        ref.watch(bottomNavigationBarStateNotifier.select((c) => c.currentIndex)),
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
    final currentIndex = ref.watch(bottomNavigationBarStateNotifier).currentIndex;
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
    await ref.read(fcmServiceProvider).requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// terminated (!= background) の状態から
    /// 通知によってアプリを開いた場合に remoteMessage が非 null となる。
    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      debugPrint('🔥 Open app from FCM when terminated.');
      final path = remoteMessage.data['path'] as String;
      final data = remoteMessage.data;
      debugPrint('*****************************');
      debugPrint('path: $path');
      debugPrint('data: $data');
      debugPrint('*****************************');
      if (remoteMessage.data.containsKey('path')) {
        await ref.read(navigationServiceProvider).pushOnCurrentTab(path: path, data: data);
      }
    }

    /// foreground or background (!= terminated) の状態から
    /// 通知によってアプリを開いた場合に発火する。
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async {
      debugPrint('🔥 FCM notification tapped.');
      if (remoteMessage.data.containsKey('path')) {
        final path = remoteMessage.data['path'] as String;
        final data = remoteMessage.data;
        debugPrint('*****************************');
        debugPrint('path: $path');
        debugPrint('data: $data');
        debugPrint('*****************************');
        await ref.read(navigationServiceProvider).pushOnCurrentTab(path: path, data: data);
      }
    });
  }

  /// Firebase Dynamic Links 関係の初期化処理を行う
  Future<void> _initializeDynamicLinks() async {
    /// background (!= terminated) でリンクを踏んだ場合
    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) async {
        debugPrint('🔗 Open app from Firebase Dynamic Links when background.');
        await ref
            .read(navigationServiceProvider)
            .popUntilFirstRouteAndPushOnSpecifiedTabByUri(pendingDynamicLinkData.link);
      },
    );

    /// terminated (!= background) の状態からリンクを踏んだ場合
    final pendingDynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
    if (pendingDynamicLinkData != null) {
      debugPrint('🔗 Open app from Firebase Dynamic Links when terminated.');
      await ref
          .read(navigationServiceProvider)
          .popUntilFirstRouteAndPushOnSpecifiedTabByUri(pendingDynamicLinkData.link);
    }
  }
}
