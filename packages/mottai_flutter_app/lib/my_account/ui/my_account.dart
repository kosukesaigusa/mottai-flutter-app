import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../host/ui/host.dart';
import '../../user/user_mode.dart';
import '../../worker/ui/worker.dart';

/// マイアカウントページ。中身は Worker や Host の詳細画面を構成するウィジェットを使用する。
@RoutePage()
class MyAccountPage extends ConsumerWidget {
  const MyAccountPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'myAccount';

  /// [MyAccountPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMode = ref.watch(userModeStateProvider);
    return AuthDependentBuilder(
      onAuthenticated: (userId) {
        switch (userMode) {
          case UserMode.worker:
            return WorkerPageBody(userId: userId);
          case UserMode.host:
            return HostPageBody(userId: userId);
        }
      },
    );
  }
}
