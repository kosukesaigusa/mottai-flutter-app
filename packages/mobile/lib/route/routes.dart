import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/account/account_page.dart';
import 'package:mottai_flutter_app/pages/home/home_page.dart';
import 'package:mottai_flutter_app/pages/main/main_page.dart';
import 'package:mottai_flutter_app/pages/map/map_page.dart';
import 'package:mottai_flutter_app/pages/not_found/not_found_page.dart';
import 'package:mottai_flutter_app/pages/second/second_page.dart';
import 'package:mottai_flutter_app/utils/types.dart';

/// ページ一覧
final routeBuilder = <String, PageBuilder>{
  MainPage.path: (_, args) => const MainPage(key: ValueKey(MainPage.name)),
  HomePage.path: (_, args) => const HomePage(key: ValueKey(HomePage.name)),
  MapPage.path: (_, args) => const MapPage(key: ValueKey(MapPage.name)),
  AccountPage.path: (_, args) => const AccountPage(key: ValueKey(AccountPage.name)),
  NotFoundPage.path: (_, args) => const NotFoundPage(key: ValueKey(NotFoundPage.name)),
  SecondPage.path: (_, args) =>
      SecondPage.withArguments(args: args, key: const ValueKey(SecondPage.name)),
};
