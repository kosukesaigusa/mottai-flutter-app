import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mottai_flutter_app/utils/enums.dart';

part 'bottom_navigation_bar_state.freezed.dart';

@freezed
class BottomNavigationBarState with _$BottomNavigationBarState {
  factory BottomNavigationBarState({
    @Default(1) int currentIndex,
    @Default(BottomNavigationBarItemName.home) BottomNavigationBarItemName itemName,
  }) = _TabState;
}
