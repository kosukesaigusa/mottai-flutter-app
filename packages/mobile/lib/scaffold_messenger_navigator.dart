import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:mottai_flutter_app/pages/not_found/not_found_page.dart';
import 'package:mottai_flutter_app/route/app_router.dart';
import 'package:mottai_flutter_app/route/routes.dart';

final appRouter = AppRouter.create(routeBuilder);

/// Widget Tree の最上部で ScaffoldMessenger を含めるための Navigator ウィジェット。
/// 目には見えないが、アプリケーション上の全てのページがこの Scaffold の上に載るので
/// ScaffoldMessengerController でどこからでもスナックバーが表示できるようになっている。
class ScaffoldMessengerNavigator extends HookConsumerWidget {
  const ScaffoldMessengerNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldMessenger(
      key: ref.watch(scaffoldMessengerController).scaffoldMessengerKey,
      child: Scaffold(
        body: Navigator(
          key: ref.watch(scaffoldMessengerController).navigatorKey,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: appRouter.generateRoute,
          onUnknownRoute: (settings) {
            final route = MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => const NotFoundPage(),
            );
            return route;
          },
        ),
      ),
    );
  }
}
