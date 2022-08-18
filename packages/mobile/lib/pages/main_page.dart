import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/bottom_tab/bottom_tab.dart';
import '../utils/firebase_messaging.dart';
import '../utils/logger.dart';
import '../utils/routing/app_router.dart';
import '../utils/scaffold_messenger.dart';
import 'not_found_page.dart';

/// Consistent な BottomNavigationBar を含むアプリのメインのページ。
/// 目には見えないが、アプリケーション上の全てのページがこの Scaffold の上に載るので
/// ScaffoldMessengerService でどこからでもスナックバーなどが表示できるようになっている。
class MainPage extends StatefulHookConsumerWidget {
  const MainPage({super.key});

  static const path = '/';
  static const name = 'MainPage';
  static const location = path;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// 必要な初期化処理を行う
    Future.wait<void>([
      ref.read(initializeFirebaseMessagingProvider)(),
    ]);
  }

  /// アプリのライフサイクルを監視する。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.info('AppLifecycleState: ${state.name}');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: ref.watch(scaffoldMessengerKeyProvider),
      child: Scaffold(
        body: Stack(
          children: [for (final tab in bottomTabs) _buildStackedPages(tab)],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedFontSize: 12,
          onTap: (index) => ref.read(bottomNavigationBarItemOnTapProvider)(index),
          currentIndex: ref.watch(bottomTabStateProvider).index,
          items: bottomTabs
              .map(
                (b) => BottomNavigationBarItem(
                  icon: ref.watch(bottomTabIconProvider(b.bottomTabEnum)),
                  label: b.bottomTabEnum.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// MainPage の BottomNavigationBar で切り替える各画面
  Widget _buildStackedPages(BottomTab bottomTab) {
    final currentBottomTab = ref.watch(bottomTabStateProvider);
    return Offstage(
      offstage: bottomTab != currentBottomTab,
      child: TickerMode(
        enabled: bottomTab == currentBottomTab,
        child: MainStackedPagesNavigator(bottomTab: bottomTab),
      ),
    );
  }
}

/// MainPage の body で Stack で重ねて、
/// Offstage で表示・非表示を切り替えているページの中身。
/// MainPage の BottomNavigationItem に対応する body のそれぞれに
/// Navigator が複数定義されている。
class MainStackedPagesNavigator extends HookConsumerWidget {
  const MainStackedPagesNavigator({
    super.key,
    required this.bottomTab,
  });

  final BottomTab bottomTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: bottomTab.key,
      initialRoute: MainPage.location,
      // MainPage の StackedPages 上での Navigation の設定
      onGenerateRoute: (routeSettings) => ref.watch(appRouterProvider).onGenerateRoute(
            routeSettings,
            bottomNavigationPath: bottomTab.bottomTabEnum.location,
          ),
      onUnknownRoute: (settings) {
        final route = MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => const NotFoundPage(),
        );
        return route;
      },
    );
  }
}
