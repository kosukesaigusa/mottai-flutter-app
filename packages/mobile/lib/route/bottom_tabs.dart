import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pages/account/account_page.dart';
import '../pages/attending_rooms/attending_rooms_page.dart';
import '../pages/home/home_page.dart';
import '../pages/map/map_page.dart';

/// BottomTab の種別。
enum BottomTabEnum {
  home(label: 'ホーム', location: HomePage.location),
  map(label: 'マップ', location: MapPage.location),
  rooms(label: 'メッセージ', location: RoomsPage.location),
  account(label: 'アカウント', location: AccountPage.location);

  const BottomTabEnum({required this.label, required this.location});

  final String label;
  final String location;
}

/// BottomNavigationBarItem.icon に表示するウィジェットを提供するプロバイダ。
final bottomTabIconProvider = Provider.family<Widget, BottomTabEnum>((ref, bottomTabEnum) {
  switch (bottomTabEnum) {
    case BottomTabEnum.home:
      return const Icon(Icons.home);
    case BottomTabEnum.map:
      return const Icon(Icons.map);
    case BottomTabEnum.rooms:
      return const Icon(Icons.mail);
    case BottomTabEnum.account:
      return const Icon(Icons.person);
  }
});

final bottomTabs = <BottomTab>[
  BottomTab._(
    index: 0,
    key: GlobalKey<NavigatorState>(),
    bottomTabEnum: BottomTabEnum.home,
  ),
  BottomTab._(
    index: 1,
    key: GlobalKey<NavigatorState>(),
    bottomTabEnum: BottomTabEnum.map,
  ),
  BottomTab._(
    index: 2,
    key: GlobalKey<NavigatorState>(),
    bottomTabEnum: BottomTabEnum.rooms,
  ),
  BottomTab._(
    index: 3,
    key: GlobalKey<NavigatorState>(),
    bottomTabEnum: BottomTabEnum.account,
  ),
];

/// MainPage の BottomNavigationBar の内容。
class BottomTab {
  const BottomTab._({
    required this.index,
    required this.key,
    required this.bottomTabEnum,
  });

  final int index;
  final GlobalKey<NavigatorState> key;
  final BottomTabEnum bottomTabEnum;
}
