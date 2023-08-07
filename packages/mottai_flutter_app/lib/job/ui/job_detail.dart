import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../user/host.dart';
import '../job.dart';

/// 仕事詳細ページ。
@RoutePage()
class JobDetailPage extends ConsumerWidget {
  const JobDetailPage({
    @PathParam('jobId') required this.jobId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/jobs/:jobId';

  /// [JobDetailPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String jobId}) => '/jobs/$jobId';

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集')),
      // Jobの読み込み状態によって表示を変更
      body: ref.watch(jobFutureProvider(jobId)).when(
            data: (job) {
              if (job == null) {
                return const Center(child: Text('お手伝いが存在していません。'));
              }
              return ref.watch(hostFutureProvider(job.hostId)).when(
                    data: (readHost) {
                      if (readHost == null) {
                        return const Center(
                          child: Text('ホストが存在していません。'),
                        );
                      }
                      return _JobDetail(job: job, readHost: readHost);
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => const Center(
                      child: Text('通信に失敗しました。'),
                    ),
                  );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Center(
              child: Text('通信に失敗しました。'),
            ),
          ),
    );
  }
}

class _JobDetail extends ConsumerWidget {
  const _JobDetail({
    required this.job,
    required this.readHost,
  });

  final ReadJob job;
  final ReadHost readHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (readHost.imageUrl.isNotEmpty)
            Center(
              child: LimitedBox(
                maxHeight: 300,
                child: Image.network(readHost.imageUrl, fit: BoxFit.cover),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Section(
                  title: readHost.displayName,
                  titleStyle: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  content: Text(
                    job.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                Section(
                  title: 'お手伝いの場所',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.place,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                Section(
                  title: 'ホスト',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                  content: SelectableChips<HostType>(
                    allItems: HostType.values,
                    labels: Map.fromEntries(
                      HostType.values.map(
                        (type) => MapEntry(type, type.label),
                      ),
                    ),
                    enabledItems: readHost.hostTypes,
                  ),
                ),
                Section(
                  title: '内容',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                Section(
                  title: '持ち物',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.belongings,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                // 報酬
                Section(
                  title: '報酬',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.reward,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                Section(
                  title: 'アクセス',
                  description: job.accessDescription,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  descriptionStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                  content: SelectableChips<AccessType>(
                    allItems: AccessType.values,
                    labels: Map.fromEntries(
                      AccessType.values.map(
                        (type) => MapEntry(type, type.label),
                      ),
                    ),
                    enabledItems: job.accessTypes,
                    isDisplayDisable: false,
                  ),
                ),
                Section(
                  title: 'ひとこと',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.comment,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
                if (readHost.urls.isNotEmpty)
                  Section(
                    title: 'URL',
                    titleStyle: Theme.of(context).textTheme.headlineMedium,
                    sectionPadding: const EdgeInsets.only(bottom: 32),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: readHost.urls
                          .map(
                            (url) => WebLink(
                              urlText: url,
                              mode: LaunchMode.externalApplication,
                              linkStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                Section(
                  // TODO: 未実装
                  title: '体験者の感想',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    '仮',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: Center(
              child: ElevatedButton(
                onPressed: () {}, // TODO: 未実装
                child: const Text('このホストに連絡する'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
