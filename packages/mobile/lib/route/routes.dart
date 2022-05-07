import 'package:flutter/material.dart';

import '../pages/account/account_page.dart';
import '../pages/attending_rooms/attending_rooms_page.dart';
import '../pages/home/home_page.dart';
import '../pages/main/main_page.dart';
import '../pages/map/map_page.dart';
import '../pages/not_found/not_found_page.dart';
import '../pages/notification/notification.dart';
import '../pages/playgrounds/hero/hero_detail_page.dart';
import '../pages/playgrounds/hero/hero_page.dart';
import '../pages/playgrounds/infinite_scroll_page.dart';
import '../pages/playgrounds/playground_page.dart';
import '../pages/room/room_page.dart';
import '../pages/second/second_page.dart';
import '../utils/types.dart';
import 'utils.dart';

/// ページ一覧
final routeBuilder = <String, PageBuilder>{};

/// ページのパスと対応するビルダーメソッドをまとめた
/// AppRoute インスタンス一覧
final appRoutes = <AppRoute>[
  AppRoute(
    MainPage.path,
    (_, args) => const MainPage(key: ValueKey(MainPage.name)),
  ),
  AppRoute(
    HomePage.path,
    (_, args) => const HomePage(key: ValueKey(HomePage.name)),
  ),
  AppRoute(
    MapPage.path,
    (_, args) => const MapPage(key: ValueKey(MapPage.name)),
  ),
  AppRoute(
    AttendingRoomsPage.path,
    (_, args) => const AttendingRoomsPage(key: ValueKey(AttendingRoomsPage.name)),
  ),
  AppRoute(
    RoomPage.path,
    (_, args) => const RoomPage(key: ValueKey(RoomPage.name)),
  ),
  AppRoute(
    AccountPage.path,
    (_, args) => const AccountPage(key: ValueKey(AccountPage.name)),
  ),
  AppRoute(
    NotificationPage.path,
    (_, args) => const NotificationPage(key: ValueKey(NotificationPage.name)),
  ),
  AppRoute(
    NotFoundPage.path,
    (_, args) => const NotFoundPage(key: ValueKey(NotFoundPage.name)),
  ),
  AppRoute(
    SecondPage.path,
    (_, args) => SecondPage.withArguments(args: args, key: const ValueKey(SecondPage.name)),
  ),
  AppRoute(
    PlaygroundPage.path,
    (_, args) => const PlaygroundPage(key: ValueKey(PlaygroundPage.name)),
  ),
  AppRoute(
    InfiniteScrollPage.path,
    (_, args) => const InfiniteScrollPage(key: ValueKey(InfiniteScrollPage.name)),
  ),
  AppRoute(
    HeroImagesPage.path,
    (_, args) => HeroImagesPage(key: const ValueKey(HeroImagesPage.name)),
  ),
  AppRoute(
    HeroImageDetailPage.path,
    (_, args) => HeroImageDetailPage.withArguments(
      args: args,
      key: const ValueKey(HeroImageDetailPage.name),
    ),
  ),
  AppRoute(
    GreenContainerPage.path,
    (_, args) => const GreenContainerPage(key: ValueKey(GreenContainerPage.name)),
  ),
];
