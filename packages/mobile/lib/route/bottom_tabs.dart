import 'package:flutter/material.dart';

import '../pages/account/account_page.dart';
import '../pages/attending_rooms/attending_rooms_page.dart';
import '../pages/home/home_page.dart';
import '../pages/map/map_page.dart';

/// MainPage の BottomNavigationBarItem に対応する内容一覧。
/// さすがに override することはないと思われるので Provider は使用せず
/// イミュータブルなグローバル変数にする。
final bottomTabs = <BottomTab>[
  BottomTab._(
    index: 0,
    label: 'ホーム',
    path: HomePage.path,
    iconData: Icons.home,
    key: GlobalKey<NavigatorState>(),
  ),
  BottomTab._(
    index: 1,
    label: 'マップ',
    path: MapPage.path,
    iconData: Icons.map,
    key: GlobalKey<NavigatorState>(),
  ),
  BottomTab._(
    index: 2,
    label: 'メッセージ',
    path: AttendingRoomsPage.path,
    iconData: Icons.mail,
    key: GlobalKey<NavigatorState>(),
  ),
  BottomTab._(
    index: 3,
    label: 'アカウント',
    path: AccountPage.path,
    iconData: Icons.person,
    key: GlobalKey<NavigatorState>(),
  ),
];

/// MainPage の BottomNavigationBar の内容
class BottomTab {
  /// プライベートなコンストラクタ。このファイルの外ではインスタンス化しない。
  const BottomTab._({
    required this.index,
    required this.label,
    required this.path,
    required this.iconData,
    required this.key,
  });

  final int index;
  final String label;
  final String path;
  final IconData iconData;
  final GlobalKey<NavigatorState> key;

  /// インデックス番号を指定して対応する BottomTab を取得する。
  /// BottomTab は外でインスタンス化するつもりがないので static メソッドでよい。
  static BottomTab getByIndex(int index) => bottomTabs.firstWhere(
        (b) => b.index == index,
        orElse: () => bottomTabs.first,
      );

  /// パス名 (e.g. /home/)を指定して対応する BottomTab を取得する。
  /// BottomTab は外でインスタンス化するつもりがないので static メソッドでよい。
  static BottomTab getByPath(String bottomTabPath) => bottomTabs.firstWhere(
        (b) => b.path == bottomTabPath,
        orElse: () => bottomTabs.first,
      );
}
