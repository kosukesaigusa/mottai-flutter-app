import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/account/account_page.dart';
import 'package:mottai_flutter_app/pages/home/home_page.dart';
import 'package:mottai_flutter_app/pages/map/map_page.dart';

/// MainPage の BottomNavigationBar の enum
enum BottomTabEnum {
  home,
  map,
  account,
}

/// MainPage の BottomNavigationBar の内容
class BottomTab {
  const BottomTab({
    required this.index,
    required this.tab,
    required this.label,
    required this.path,
    required this.iconData,
  });

  final int index;
  final BottomTabEnum tab;
  final String label;
  final String path;
  final IconData iconData;
}

/// MainPage の BottomNavigationBarItem 一覧
const bottomTabs = [
  BottomTab(
    index: 0,
    tab: BottomTabEnum.home,
    label: 'ホーム',
    path: HomePage.path,
    iconData: Icons.home,
  ),
  BottomTab(
    index: 1,
    tab: BottomTabEnum.map,
    label: 'マップ',
    path: MapPage.path,
    iconData: Icons.map,
  ),
  BottomTab(
    index: 2,
    tab: BottomTabEnum.account,
    label: 'アカウント',
    path: AccountPage.path,
    iconData: Icons.person,
  ),
];
