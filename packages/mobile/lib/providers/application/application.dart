import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'application_state.dart';

final applicationStateNotifier = StateNotifierProvider<ApplicationStateNotifier, ApplicationState>(
  (ref) => ApplicationStateNotifier(),
);

/// 今は使用していない
class ApplicationStateNotifier extends StateNotifier<ApplicationState> {
  ApplicationStateNotifier() : super(const ApplicationState());
}
