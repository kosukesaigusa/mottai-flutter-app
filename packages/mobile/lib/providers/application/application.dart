import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/main_tabs.dart';
import 'application_state.dart';

final applicationStateNotifier = StateNotifierProvider<ApplicationStateNotifier, ApplicationState>(
  (ref) => ApplicationStateNotifier(),
);

class ApplicationStateNotifier extends StateNotifier<ApplicationState> {
  ApplicationStateNotifier() : super(const ApplicationState());

  final bottomTabKeys = {
    BottomTabEnum.home: GlobalKey<NavigatorState>(),
    BottomTabEnum.map: GlobalKey<NavigatorState>(),
    BottomTabEnum.message: GlobalKey<NavigatorState>(),
    BottomTabEnum.account: GlobalKey<NavigatorState>(),
  };
}
