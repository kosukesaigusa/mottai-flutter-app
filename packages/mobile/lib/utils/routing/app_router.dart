import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:tuple/tuple.dart';

import '../../pages/not_found_page.dart';
import '../exceptions/common.dart';
import '../extensions/dynamic.dart';
import 'app_route.dart';
import 'app_router_state.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<AppRouter>((_) => AppRouter(appRoutes));

class AppRouter {
  AppRouter(this.appRoutes);
  final List<AppRoute> appRoutes;
  final initialRoute = '/';

  /// MaterialApp や Navigator の onGenerateRoute に指定して、
  ///
  /// - 遷移するべき画面の決定、パスパラメータの解析
  /// - AppRoute.state の設定
  /// - トランジションアニメーションの決定
  ///
  /// を行うメソッド。
  /// GoRouter を参考にして、それよりも簡易で、複数 Navigator を用いて
  /// BottomNavigationBar を維持した画面遷移が行えるようにする目的。
  /// GoRouter がそれに対応したらこの AppRouter クラスの使用はやめて移行することも検討する。
  Route<dynamic> onGenerateRoute(
    RouteSettings routeSettings, {
    String? bottomNavigationPath,
  }) {
    try {
      final tuple2 = _analyzeRoute(
        routeSettings,
        bottomNavigationPath: bottomNavigationPath,
      );
      final appRoute = tuple2.item1;
      final appRouteState = tuple2.item2;
      final pageRoute = appRoute.pageRoute;
      if (pageRoute != null && _showHeroAnimation(appRouteState.queryParams)) {
        return pageRoute(appRouteState);
      }
      final route = MaterialPageRoute<dynamic>(
        settings: routeSettings,
        builder: (context) => appRoute.builder(
          context,
          appRouteState,
        ),
      );
      return route;
    } on RouteNotFoundException {
      final route = MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (context) => const NotFoundPage(),
      );
      return route;
    }
  }

  /// パス、パスパラメータ、クエリパラメータの解析を行い、
  /// 対応する AppRoute と extra も含めて AppRouterState を返す。
  /// その 2 つのインスタンスをまとめて返したいだけで、Tuple であることに深い理由はない。
  Tuple2<AppRoute, AppRouterState> _analyzeRoute(
    RouteSettings routeSettings, {
    String? bottomNavigationPath,
  }) {
    final location = _location(routeSettings, bottomNavigationPath: bottomNavigationPath);
    debugPrint('***');
    debugPrint('location: $location');
    var path = location;
    final extra = routeSettings.arguments;
    var queryParams = <String, String>{};
    if (location.contains('?')) {
      queryParams = Uri.parse(location).queryParameters;
      path = location.split('?').first;
    }
    final appRoute = appRoutes.firstWhere(
      (appRoute) => pathToRegExp(appRoute.path).matchAsPrefix(path) != null,
      orElse: () => throw RouteNotFoundException(path),
    );
    final parameters = <String>[];
    final match = pathToRegExp(appRoute.path, parameters: parameters).matchAsPrefix(path);
    final params = extract(parameters, match!);
    final appRouteState = AppRouterState(
      location: location,
      name: appRoute.name,
      fullpath: appRoute.path,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
    return Tuple2(appRoute, appRouteState);
  }

  /// onGenerateRoute と同じ引数を受けてパスを決定する。
  String _location(
    RouteSettings routeSettings, {
    String? bottomNavigationPath,
  }) {
    final location = routeSettings.name;
    if (location == null) {
      return '';
    }
    if (bottomNavigationPath?.isEmpty ?? true) {
      return location;
    }
    if (location == initialRoute) {
      return bottomNavigationPath!;
    }
    return location;
  }

  /// AppRouterState.queryParams から Hero アニメーションをするかどうか決定する
  bool _showHeroAnimation(Map<String, String> queryParams) {
    return queryParams['hero'].toBool;
  }
}
