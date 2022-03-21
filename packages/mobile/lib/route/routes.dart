import 'package:flutter/material.dart';

import '../pages/account/account_page.dart';
import '../pages/home/home_page.dart';
import '../pages/main/main_page.dart';
import '../pages/map/map_page.dart';
import '../pages/message/message_page.dart';
import '../pages/not_found/not_found_page.dart';
import '../pages/notification/notification.dart';
import '../pages/second/second_page.dart';
import '../utils/types.dart';

/// ページ一覧
final routeBuilder = <String, PageBuilder>{
  MainPage.path: (_, args) => const MainPage(key: ValueKey(MainPage.name)),
  HomePage.path: (_, args) => const HomePage(key: ValueKey(HomePage.name)),
  MapPage.path: (_, args) => const MapPage(key: ValueKey(MapPage.name)),
  MessagePage.path: (_, args) => const MessagePage(key: ValueKey(MessagePage.name)),
  AccountPage.path: (_, args) => const AccountPage(key: ValueKey(AccountPage.name)),
  NotificationPage.path: (_, args) => const NotificationPage(key: ValueKey(NotificationPage.name)),
  NotFoundPage.path: (_, args) => const NotFoundPage(key: ValueKey(NotFoundPage.name)),
  SecondPage.path: (_, args) =>
      SecondPage.withArguments(args: args, key: const ValueKey(SecondPage.name)),
};
