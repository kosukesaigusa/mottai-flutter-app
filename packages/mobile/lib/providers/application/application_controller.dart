import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/main_tabs.dart';
import 'application_state.dart';

final applicationStateNotifier = StateNotifierProvider<ApplicationStateNotifier, ApplicationState>(
  (ref) => ApplicationStateNotifier(),
);

class ApplicationStateNotifier extends StateNotifier<ApplicationState> {
  ApplicationStateNotifier() : super(const ApplicationState());

  final navigatorKeys = {
    BottomTabEnum.home: GlobalKey<NavigatorState>(),
    BottomTabEnum.map: GlobalKey<NavigatorState>(),
    BottomTabEnum.message: GlobalKey<NavigatorState>(),
    BottomTabEnum.account: GlobalKey<NavigatorState>(),
  };

  // /// ローディングを開始する。
  // /// Duration を指定しなければ 5 秒後に戻る。
  // void startLoading({Duration duration = const Duration(seconds: 5)}) {
  //   state = state.copyWith(loading: true);
  //   Future<void>.delayed(duration, () {
  //     state = state.copyWith(loading: false);
  //   });
  // }

  // /// ローディングを終了する
  // void endLoading() {
  //   state = state.copyWith(loading: false);
  // }
}
