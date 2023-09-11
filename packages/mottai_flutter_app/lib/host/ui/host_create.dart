import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import 'host_form.dart';

/// 仕事情報更新ページ。
@RoutePage()
class HostCreatePage extends ConsumerWidget {
  const HostCreatePage({
    super.key,
  });

  static const path = '/hosts/create';

  /// [HostCreatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      // TODO:なるんさんが実装中の「本人かどうかビルダー」に後で書き換える。
      body: AuthDependentBuilder(
        onAuthenticated: (hostId) {
          return HostForm.create(workerId: hostId);
        },
      ),
    );
  }
}
