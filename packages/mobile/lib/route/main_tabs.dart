import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/pages/account/account_page.dart';
import 'package:mottai_flutter_app/pages/home/home_page.dart';
import 'package:mottai_flutter_app/pages/map/map_page.dart';

class BottomNavigationBarItemData {
  const BottomNavigationBarItemData({
    required this.index,
    required this.item,
    required this.label,
    required this.path,
    required this.iconData,
  });

  final int index;
  final BottomNavigationBarItemEnum item;
  final String label;
  final String path;
  final IconData iconData;
}

enum BottomNavigationBarItemEnum {
  home,
  map,
  account,
}

/// MainPage の BottomNavigationBarItem 一覧
const bottomNavigationBarItems = [
  BottomNavigationBarItemData(
    index: 0,
    item: BottomNavigationBarItemEnum.home,
    label: 'ホーム',
    path: HomePage.path,
    iconData: Icons.home,
  ),
  BottomNavigationBarItemData(
    index: 1,
    item: BottomNavigationBarItemEnum.map,
    label: 'マップ',
    path: MapPage.path,
    iconData: Icons.map,
  ),
  BottomNavigationBarItemData(
    index: 2,
    item: BottomNavigationBarItemEnum.account,
    label: 'アカウント',
    path: AccountPage.path,
    iconData: Icons.person,
  ),
];
