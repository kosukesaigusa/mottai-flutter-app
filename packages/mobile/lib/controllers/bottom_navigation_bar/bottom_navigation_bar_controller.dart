import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_state.dart';
import 'package:mottai_flutter_app/route/main_tabs.dart';
import 'package:state_notifier/state_notifier.dart';

final bottomNavigationBarController =
    StateNotifierProvider<BottomNavigationBarController, BottomNavigationBarState>(
  (ref) => BottomNavigationBarController(),
);

class BottomNavigationBarController extends StateNotifier<BottomNavigationBarState>
    with LocatorMixin {
  BottomNavigationBarController()
      : super(BottomNavigationBarState(
          currentIndex: 0,
          currentTab: BottomTabEnum.home,
        ));

  /// 表示中の BottomNavigationBar を更新する。
  void changeTab({
    required int index,
    required BottomTabEnum tab,
  }) {
    state = state.copyWith(currentIndex: index, currentTab: tab);
  }
}
