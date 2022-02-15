import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_navigation_bar_state.freezed.dart';

@freezed
class BottomNavigationBarState with _$BottomNavigationBarState {
  factory BottomNavigationBarState({@Default(0) int currentIndex}) = _TabState;
}
