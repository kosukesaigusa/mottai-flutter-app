import 'package:flutter/material.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';

import '../pages/not_found/not_found_page.dart';
import '../pages/playgrounds/hero/hero_detail_page.dart';
import '../utils/types.dart';
import 'custom_hero_router.dart';
import 'utils.dart';

abstract class AppRouter {
  factory AppRouter.create(Map<String, PageBuilder> routeMap) => _AppRouterImpl(routeMap);

  static const initialRoute = '/';
  Route<dynamic> generateRoute(RouteSettings settings, {String bottomNavigationPath});
}

class _AppRouterImpl implements AppRouter {
  _AppRouterImpl(Map<String, PageBuilder> routeMap)
      : appRoutes = <AppRoute>[for (final key in routeMap.keys) AppRoute(key, routeMap[key]!)];

  final List<AppRoute> appRoutes;

  @override
  Route<dynamic> generateRoute(RouteSettings settings, {String? bottomNavigationPath}) {
    var path = settings.name!;
    if (bottomNavigationPath?.isEmpty ?? true) {
      path = settings.name!;
    } else {
      path = (settings.name == AppRouter.initialRoute ? bottomNavigationPath : settings.name)!;
    }
    debugPrint('*****************************');
    debugPrint('path: $path');
    debugPrint('*****************************');

    // path に ? がついている場合は、それ以降をクエリストリングとみなし、
    // 分割して `queryParams` というマップに追加する。
    // path は ? 以前の文字列で上書きしておく。
    // 現状 fullScreenDialog=true くらいしか使いみちはない。
    var queryParams = <String, dynamic>{};
    if (path.contains('?')) {
      queryParams = Uri.parse(path).queryParameters;
      path = path.split('?').first;
    }

    // ページに渡す引数の Map<String, dynamic>
    final data = (settings.arguments as RouteArguments?)?.data ?? <String, dynamic>{};

    try {
      // appRoutes の各要素のパスに一致する AppRoute を見つけて
      // 遷移先の Widget の MaterialPageRoute を返す
      final appRoute = appRoutes.firstWhere(
        (appRoute) => appRoute.path == path,
        orElse: () => throw RouteNotFoundException(path),
      );
      if (path == '/hero-detail/') {
        final customRoute = CustomHeroPageRouter(
          builder: (_) => HeroImageDetailPage.withArguments(
            args: RouteArguments(data),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        );
        return customRoute;
      } else {
        final route = MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (context) => appRoute.pageBuilder(context, RouteArguments(data)),
          fullscreenDialog: toBool(queryParams['fullScreenDialog'] ?? false),
        );
        return route;
      }
    } on RouteNotFoundException {
      final route = MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => const NotFoundPage(),
      );
      return route;
    }
  }
}
