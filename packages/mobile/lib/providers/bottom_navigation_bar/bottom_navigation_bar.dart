import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/main_tabs.dart';
import 'bottom_navigation_bar_state.dart';

final bottomNavigationBarStateNotifier =
    StateNotifierProvider<BottomNavigationBarStateNotifier, BottomNavigationBarState>(
  (ref) => BottomNavigationBarStateNotifier(),
);

class BottomNavigationBarStateNotifier extends StateNotifier<BottomNavigationBarState> {
  BottomNavigationBarStateNotifier()
      : super(BottomNavigationBarState(currentBottomTab: bottomTabs[0]));

  /// 表示中の BottomNavigationBar を更新する。
  void changeTab(BottomTab bottomTab) {
    state = state.copyWith(currentBottomTab: bottomTab);
  }
}
