import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pages/not_found/not_found_page.dart';
import 'providers/overlay_loading/overlay_loading.dart';
import 'providers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'route/app_router.dart';
import 'route/routes.dart';
import 'widgets/common/loading.dart';

final appRouter = AppRouter.create(routeBuilder);

/// Widget Tree の最上部で ScaffoldMessenger を含めるための Navigator ウィジェット。
/// 目には見えないが、アプリケーション上の全てのページがこの Scaffold の上に載るので
/// ScaffoldMessengerController でどこからでもスナックバーが表示できるようになっている。
class ScaffoldMessengerNavigator extends HookConsumerWidget {
  const ScaffoldMessengerNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardVisibilityProvider(
      child: ScaffoldMessenger(
        key: ref.watch(scaffoldMessengerController.select((c) => c.scaffoldMessengerKey)),
        child: Scaffold(
          body: Stack(
            children: [
              Navigator(
                key: ref.watch(scaffoldMessengerController.select((c) => c.navigatorKey)),
                initialRoute: AppRouter.initialRoute,
                onGenerateRoute: appRouter.generateRoute,
                observers: const [],
                onUnknownRoute: (settings) {
                  final route = MaterialPageRoute<void>(
                    settings: settings,
                    builder: (context) => const NotFoundPage(),
                  );
                  return route;
                },
              ),
              if (ref.watch(overlayLoadingProvider)) const OverlayLoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
