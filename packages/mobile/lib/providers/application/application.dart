import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'application_state.dart';

final applicationStateNotifier = StateNotifierProvider<ApplicationStateNotifier, ApplicationState>(
  (ref) => ApplicationStateNotifier(),
);

/// いまは使いみちがないが、アプリケーション全体の状態管理や初期化ロジックなどを書く
class ApplicationStateNotifier extends StateNotifier<ApplicationState> {
  ApplicationStateNotifier() : super(const ApplicationState());
}
