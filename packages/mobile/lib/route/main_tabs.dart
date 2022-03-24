import 'package:flutter/material.dart';

import '../pages/account/account_page.dart';
import '../pages/attending_rooms/attending_rooms_page.dart';
import '../pages/home/home_page.dart';
import '../pages/map/map_page.dart';

/// MainPage の BottomNavigationBar の enum
enum BottomTabEnum {
  home,
  map,
  message,
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
    index: 1,
    tab: BottomTabEnum.message,
    label: 'メッセージ',
    path: AttendingRoomsPage.path,
    iconData: Icons.mail,
  ),
  BottomTab(
    index: 2,
    tab: BottomTabEnum.account,
    label: 'アカウント',
    path: AccountPage.path,
    iconData: Icons.person,
  ),
];

/// BottomTabEnum から タブの index を取得する。
int getIndexByTab(BottomTabEnum tab) {
  return bottomTabs
      .firstWhere(
        (bottomTab) => bottomTab.tab == tab,
        orElse: () => bottomTabs[0],
      )
      .index;
}

/// タブの名前からタブを取得する。
BottomTabEnum getTabByTabName(String tabName) {
  return BottomTabEnum.values.firstWhere(
    (tab) => tab.name == tabName,
    orElse: () => BottomTabEnum.home,
  );
}
