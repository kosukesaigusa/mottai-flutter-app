import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
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
      // Jobの読み込み状態によって表示を変更
      body: ref.watch(jobFutureProvider(jobId)).when(
            data: (job) {
              if (job == null) {
                return const Center(child: Text('お手伝いが存在していません。'));
              }
              // UrlのhostIdとログイン中のユーザーのhostIdが違う場合
              if (job.hostId != ref.watch(userIdProvider)) {
                return const Center(
                  child: Text('編集の権限がありません。'),
                );
              }
              return JobForm(
                job: job,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Center(
              child: Text('仕事情報が取得できませんでした。'),
            ),
          ),
    );
  }
}
