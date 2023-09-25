import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import 'job_form.dart';

/// 仕事情報更新ページ。
@RoutePage()
class JobCreatePage extends ConsumerWidget {
  const JobCreatePage({
    super.key,
  });

  static const path = '/jobs/create';

  /// [JobCreatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return JobForm.create(hostId: userId);
        },
      ),
    );
  }
}
