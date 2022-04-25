import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../pages/main/main_page.dart';
import '../../pages/not_found/not_found_page.dart';
import '../../providers/application/application.dart';
import '../../route/app_router.dart';
import '../../route/main_tabs.dart';
import '../../route/routes.dart';

final appRouter = AppRouter.create(routeBuilder);

class MainStackedPagesNavigator extends HookConsumerWidget {
  const MainStackedPagesNavigator({
    Key? key,
    required this.tab,
  }) : super(key: key);

  final BottomTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: ref.watch(applicationStateNotifier.notifier).bottomTabKeys[tab.tab],
      initialRoute: MainPage.path,
      observers: [
        HeroController(),
      ],
      // MainPage の StackedPages 上での Navigation なので
      // tab.path を渡す
      onGenerateRoute: (routeSettings) => appRouter.generateRoute(
        routeSettings,
        bottomNavigationPath: tab.path,
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
