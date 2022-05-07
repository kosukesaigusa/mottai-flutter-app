import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';

import '../constants/map.dart';
import '../pages/not_found/not_found_page.dart';
import '../pages/playgrounds/hero/hero_detail_page.dart';
import 'custom_hero_router.dart';
import 'utils.dart';

final routerProvider = Provider.family<Router, List<AppRoute>>(
  (_, appRoutes) => Router(appRoutes),
);

class Router {
  Router(this.appRoutes);

  final List<AppRoute> appRoutes;
  final initialRoute = '/';

  Route<dynamic> onGenerateRoute(RouteSettings routeSettings, {String? bottomNavigationPath}) {
    var path = _path(routeSettings, bottomNavigationPath: bottomNavigationPath);
    debugPrint('***');
    debugPrint('path: $path');

    // path に ? がついている場合は、それ以降をクエリストリングとみなし、
    // 分割して `queryParams` というマップに追加する。
    // path は ? 以前の文字列で上書きしておく。
    // 現状 fullScreenDialog=true くらいしか使いみちはない。
    var queryParams = emptyMap;
    if (path.contains('?')) {
      queryParams = Uri.parse(path).queryParameters;
      path = path.split('?').first;
    }

    // ページに渡す引数の Map<String, dynamic>
    final data = (routeSettings.arguments as RouteArguments?)?.data ?? emptyMap;

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
          settings: routeSettings,
          builder: (context) => appRoute.pageBuilder(context, RouteArguments(data)),
          fullscreenDialog: toBool(queryParams['fullScreenDialog'] ?? false),
        );
        return route;
      }
    } on RouteNotFoundException {
      final route = MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (context) => const NotFoundPage(),
      );
      return route;
    }
  }

  /// onGenerateRoute と同じ引数を受けてパスを決定する。
  String _path(RouteSettings routeSettings, {String? bottomNavigationPath}) {
    final path = routeSettings.name;
    if (path == null) {
      return '';
    }
    if (bottomNavigationPath?.isEmpty ?? true) {
      return path;
    }
    if (path == initialRoute) {
      return bottomNavigationPath!;
    }
    return path;
  }
}
