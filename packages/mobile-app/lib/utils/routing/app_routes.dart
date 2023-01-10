import 'package:flutter/material.dart';

import '../../features/account/ui/account_page.dart';
import '../../features/map/ui/map_page.dart';
import '../../main_page.dart';
import 'app_route.dart';

/// AppRoute インスタンスの一覧
/// 各ページのコンストラクタに引数を渡さない済むように、そのような場合は ProviderScope.override で
/// appRouterStateProvider の値をオーバーライドして、各画面を AppState をオーバーライドされた
/// Provider 経由で取得するようにする。
final appRoutes = <AppRoute>[
  AppRoute(
    path: MainPage.path,
    name: MainPage.name,
    builder: (context, state) => const MainPage(key: ValueKey(MainPage.name)),
  ),
  AppRoute(
    path: MapPage.path,
    name: MapPage.name,
    builder: (context, state) => const MapPage(key: ValueKey(MapPage.name)),
  ),
  AppRoute(
    path: AccountPage.path,
    name: AccountPage.name,
    builder: (context, state) =>
        const AccountPage(key: ValueKey(AccountPage.name)),
  ),
];
