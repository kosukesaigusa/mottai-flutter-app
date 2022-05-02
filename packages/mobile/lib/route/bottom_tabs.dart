import 'package:flutter/material.dart';

import '../pages/account/account_page.dart';
import '../pages/attending_rooms/attending_rooms_page.dart';
import '../pages/home/home_page.dart';
import '../pages/map/map_page.dart';

/// MainPage の BottomNavigationBarItem 一覧。
/// さすがに override することはないのでイミュータブルなグローバル変数にする。
final bottomTabs = BottomTabEnum.values.map(BottomTab.fromTab).toList();

/// MainPage の BottomNavigationBar の enum
enum BottomTabEnum {
  home,
  map,
  message,
  account,
}

/// MainPage の BottomNavigationBar の内容
class BottomTab {
  /// プライベートなコンストラクタ
  const BottomTab._({
    required this.index,
    required this.tab,
    required this.label,
    required this.path,
    required this.iconData,
    required this.key,
  });

  factory BottomTab.home() => BottomTab._(
        index: 0,
        tab: BottomTabEnum.home,
        label: 'ホーム',
        path: HomePage.path,
        iconData: Icons.home,
        key: GlobalKey<NavigatorState>(),
      );

  factory BottomTab.map() => BottomTab._(
        index: 1,
        tab: BottomTabEnum.map,
        label: 'マップ',
        path: MapPage.path,
        iconData: Icons.map,
        key: GlobalKey<NavigatorState>(),
      );

  factory BottomTab.message() => BottomTab._(
        index: 2,
        tab: BottomTabEnum.message,
        label: 'メッセージ',
        path: AttendingRoomsPage.path,
        iconData: Icons.mail,
        key: GlobalKey<NavigatorState>(),
      );

  factory BottomTab.account() => BottomTab._(
        index: 3,
        tab: BottomTabEnum.account,
        label: 'アカウント',
        path: AccountPage.path,
        iconData: Icons.person,
        key: GlobalKey<NavigatorState>(),
      );

  /// BottomTabEnum によるコンストラクタ
  factory BottomTab.fromTab(BottomTabEnum tab) {
    switch (tab) {
      case BottomTabEnum.home:
        return BottomTab.home();
      case BottomTabEnum.map:
        return BottomTab.map();
      case BottomTabEnum.message:
        return BottomTab.message();
      case BottomTabEnum.account:
        return BottomTab.account();
    }
  }

  /// タブの名前によるコンストラクタ（FCM や Deep Link のパス文字列など）
  factory BottomTab.fromString(String name) {
    switch (name) {
      case 'home':
        return BottomTab.home();
      case 'map':
        return BottomTab.map();
      case 'message':
        return BottomTab.message();
      case 'account':
        return BottomTab.account();
      default:
        return BottomTab.home();
    }
  }

  final int index;
  final BottomTabEnum tab;
  final String label;
  final String path;
  final IconData iconData;
  final GlobalKey<NavigatorState> key;
}
