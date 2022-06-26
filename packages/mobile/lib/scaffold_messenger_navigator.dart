import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pages/not_found/not_found_page.dart';
import 'providers/overlay_loading/overlay_loading.dart';
import 'route/app_router.dart';
import 'services/navigation.dart';
import 'services/scaffold_messenger_service.dart';
import 'widgets/loading/loading.dart';

/// Widget Tree の最上部で ScaffoldMessenger を含めるための Navigator ウィジェット。
/// 目には見えないが、アプリケーション上の全てのページがこの Scaffold の上に載るので
/// ScaffoldMessengerService でどこからでもスナックバーが表示できるようになっている。
class ScaffoldMessengerNavigator extends HookConsumerWidget {
  const ScaffoldMessengerNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: ref.read(navigationServiceProvider).maybePop,
      child: KeyboardVisibilityProvider(
        child: ScaffoldMessenger(
          key: ref.watch(scaffoldMessengerServiceProvider.select((c) => c.scaffoldMessengerKey)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: Stack(
                children: [
                  Navigator(
                    key: ref.watch(scaffoldMessengerServiceProvider.select((c) => c.navigatorKey)),
                    initialRoute: ref.watch(appRouterProvider).initialRoute,
                    onGenerateRoute: ref.watch(appRouterProvider).onGenerateRoute,
                    onUnknownRoute: (settings) {
                      final route = MaterialPageRoute<void>(
                        settings: settings,
                        builder: (context) => const NotFoundPage(),
                      );
                      return route;
                    },
                  ),
                  if (ref.watch(overlayLoadingProvider)) const OverlayLoadingWidget(),
                  // const ForceUpdateWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
