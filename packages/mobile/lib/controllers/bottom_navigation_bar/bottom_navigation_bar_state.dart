import 'package:freezed_annotation/freezed_annotation.dart';

import '../../route/main_tabs.dart';

part 'bottom_navigation_bar_state.freezed.dart';

@freezed
class BottomNavigationBarState with _$BottomNavigationBarState {
  factory BottomNavigationBarState({
    @Default(0) int currentIndex,
    @Default(BottomTabEnum.home) BottomTabEnum currentTab,
  }) = _TabState;
}
