import 'package:freezed_annotation/freezed_annotation.dart';

import '../../route/bottom_tabs.dart';

part 'bottom_navigation_bar_state.freezed.dart';

@freezed
class BottomNavigationBarState with _$BottomNavigationBarState {
  factory BottomNavigationBarState({
    required BottomTab currentBottomTab,
  }) = _TabState;
}
