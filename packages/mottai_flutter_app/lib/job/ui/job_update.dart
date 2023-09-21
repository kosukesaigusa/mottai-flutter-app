import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../job.dart';
import 'job_form.dart';

/// 仕事情報更新ページ。
@RoutePage()
class JobUpdatePage extends ConsumerWidget {
  const JobUpdatePage({
    @PathParam('jobId') required this.jobId,
    super.key,
  });

  static const path = '/jobs/:jobId/update';

  /// [JobUpdatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String jobId}) => '/jobs/$jobId/update';

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(jobFutureProvider(jobId));
    final job = asyncValue.valueOrNull;
    final isLoading = asyncValue.isLoading;
    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Center(child: Text('お手伝いが存在しません。')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      body: UserAuthDependentBuilder(
        userId: job.hostId,
        onAuthenticated: (userId, isUserAuthenticated) {
          if (!isUserAuthenticated) {
            return const Center(child: Text('このお手伝いは編集できません。'));
          }
          return JobForm.update(hostId: userId, job: job);
        },
      ),
    );
  }
}
