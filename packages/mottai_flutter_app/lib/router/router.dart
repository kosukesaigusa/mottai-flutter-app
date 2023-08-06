import 'package:auto_route/auto_route.dart';

import '../chat/ui/chat_room.dart';
import '../development/development_items/ui/development_items.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    RedirectRoute(path: '/', redirectTo: DevelopmentItemsPage.path),
    AutoRoute(
      path: ChatRoomPage.path,
      page: ChatRoomRoute.page,
    ),
    // NOTE: 以下、開発用のページ。
    AutoRoute(
      path: DevelopmentItemsPage.path,
      page: DevelopmentItemsRoute.page,
    ),
  ];
}
