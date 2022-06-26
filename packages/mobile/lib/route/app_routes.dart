import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pages/account/account_page.dart';
import '../pages/home/home_page.dart';
import '../pages/main/main_page.dart';
import '../pages/map/map_page.dart';
import '../pages/notification/notification_page.dart';
import '../pages/room/room_page.dart';
import '../pages/rooms/rooms_page.dart';
import '../pages/second/second_page.dart';
import 'app_route.dart';
import 'app_router_state.dart';

/// GoRouter を一部参考にして簡易に実装した AppRoute インスタンスの一覧
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
    path: HomePage.path,
    name: HomePage.name,
    builder: (context, state) => const HomePage(key: ValueKey(HomePage.name)),
  ),
  AppRoute(
    path: SecondPage.path,
    name: SecondPage.name,
    builder: (context, state) => ProviderScope(
      overrides: <Override>[appRouterStateProvider.overrideWithValue(state)],
      child: const SecondPage(key: ValueKey(SecondPage.name)),
    ),
  ),
  AppRoute(
    path: MapPage.path,
    name: MapPage.name,
    builder: (context, state) => const MapPage(key: ValueKey(MapPage.name)),
  ),
  AppRoute(
    path: RoomsPage.path,
    name: RoomsPage.name,
    builder: (context, state) => ProviderScope(
      overrides: <Override>[appRouterStateProvider.overrideWithValue(state)],
      child: const RoomsPage(key: ValueKey(RoomsPage.name)),
    ),
  ),
  AppRoute(
    path: RoomPage.path,
    name: RoomPage.name,
    builder: (context, state) => ProviderScope(
      overrides: <Override>[appRouterStateProvider.overrideWithValue(state)],
      child: const RoomPage(key: ValueKey(RoomPage.name)),
    ),
  ),
  AppRoute(
    path: AccountPage.path,
    name: AccountPage.name,
    builder: (context, state) => const AccountPage(key: ValueKey(AccountPage.name)),
  ),
  AppRoute(
    path: NotificationPage.path,
    name: NotificationPage.name,
    builder: (context, state) => const NotificationPage(key: ValueKey(NotificationPage.name)),
  ),
];
