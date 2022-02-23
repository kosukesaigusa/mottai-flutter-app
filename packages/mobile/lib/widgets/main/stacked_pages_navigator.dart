import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/application/application_controller.dart';
import 'package:mottai_flutter_app/pages/main/main_page.dart';
import 'package:mottai_flutter_app/pages/not_found/not_found_page.dart';
import 'package:mottai_flutter_app/route/app_router.dart';
import 'package:mottai_flutter_app/route/main_tabs.dart';
import 'package:mottai_flutter_app/route/routes.dart';

final appRouter = AppRouter.create(routeBuilder);

class MainStackedPagesNavigator extends HookConsumerWidget {
  const MainStackedPagesNavigator({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BottomNavigationBarItemData item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: ref.watch(applicationController.notifier).navigatorKeys[item.item],
      initialRoute: MainPage.path,
      // MainPage の StackedPages 上での Navigation なので
      // item.path を渡す
      onGenerateRoute: (routeSettings) => appRouter.generateRoute(
        routeSettings,
        bottomNavigationPath: item.path,
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
