import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/application/application_state.dart';
import 'package:mottai_flutter_app/route/main_tabs.dart';

final applicationController = StateNotifierProvider<ApplicationController, ApplicationState>(
  (ref) => ApplicationController(),
);

class ApplicationController extends StateNotifier<ApplicationState> {
  ApplicationController() : super(const ApplicationState());

  // Map<BottomTabEnum, GlobalKey<NavigatorState>> navigatorKeys = {};
  final navigatorKeys = {
    BottomTabEnum.home: GlobalKey<NavigatorState>(),
    BottomTabEnum.map: GlobalKey<NavigatorState>(),
    BottomTabEnum.account: GlobalKey<NavigatorState>(),
  };

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
