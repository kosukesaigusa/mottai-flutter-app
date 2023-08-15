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
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      // TODO:なるんさんが実装中の「本人かどうかビルダー」に後で書き換える。
      // すると 「編集の権限がありません。」のチェックはその時点で済んでいることになる。
      body: AuthDependentBuilder(
        onAuthenticated: (hostId) {
          return ref.watch(jobFutureProvider(jobId)).when(
                data: (job) {
                  if (job == null) {
                    return const Center(child: Text('お手伝いが存在していません。'));
                  }
                  // UrlのhostIdとログイン中のユーザーのhostIdが違う場合
                  if (job.hostId != hostId) {
                    return const Center(
                      child: Text('編集の権限がありません。'),
                    );
                  }
                  return JobForm.update(hostId: hostId, job: job);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(
                  child: Text('仕事情報が取得できませんでした。'),
                ),
              );
        },
      ),
    );
  }
}
