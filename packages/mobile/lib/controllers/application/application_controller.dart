import 'package:mottai_flutter_app/controllers/application/application_state.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_controller.dart';
import 'package:state_notifier/state_notifier.dart';

class ApplicationController extends StateNotifier<ApplicationState> with LocatorMixin {
  ApplicationController() : super(const ApplicationState());

  BottomNavigationBarController get bottomNavigationBarController => read();

  /// ローディングを開始する。
  /// Duration を指定しなければ 5 秒後に戻る。
  void startLoading({Duration duration = const Duration(seconds: 5)}) {
    state = state.copyWith(loading: true);
    Future<void>.delayed(duration, () {
      state = state.copyWith(loading: false);
    });
  }

  /// ローディングを終了する
  void endLoading() {
    state = state.copyWith(loading: false);
  }
}
