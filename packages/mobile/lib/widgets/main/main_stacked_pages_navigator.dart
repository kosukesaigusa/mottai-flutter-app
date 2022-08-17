import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../pages/main_page.dart';
import '../../pages/not_found_page.dart';
import '../../route/app_router.dart';
import '../../route/bottom_tabs.dart';

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
      initialRoute: MainPage.path,
      observers: [
        HeroController(),
      ],
      // MainPage の StackedPages 上での Navigation の設定
      onGenerateRoute: (routeSettings) => ref
          .watch(appRouterProvider)
          .onGenerateRoute(routeSettings, bottomNavigationPath: bottomTab.bottomTabEnum.location),
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
