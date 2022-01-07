import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_state.dart';
import 'package:mottai_flutter_app/utils/enums.dart';
import 'package:state_notifier/state_notifier.dart';

class BottomNavigationBarController extends StateNotifier<BottomNavigationBarState>
    with LocatorMixin {
  BottomNavigationBarController()
      : super(BottomNavigationBarState(
          currentIndex: 0,
          itemName: BottomNavigationBarItemName.home,
        ));
}
