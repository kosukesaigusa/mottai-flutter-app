import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/controllers/application/application_controller.dart';
import 'package:mottai_flutter_app/pages/main/main_page.dart';
import 'package:mottai_flutter_app/pages/not_found/not_found_page.dart';
import 'package:mottai_flutter_app/route/app_router.dart';
import 'package:mottai_flutter_app/route/main_tabs.dart';
import 'package:mottai_flutter_app/route/routes.dart';
import 'package:provider/provider.dart';

final appRouter = AppRouter.create(routeBuilder);

class MainStackedPagesNavigator extends StatelessWidget {
  const MainStackedPagesNavigator({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BottomNavigationBarItemData item;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: context.watch<ApplicationController>().navigatorKeys[item.item],
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
