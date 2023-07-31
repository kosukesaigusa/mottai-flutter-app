import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import '../../user/host.dart';

final jobFutureProvider =
    FutureProvider.family.autoDispose<ReadJob?, String>((ref, id) async {
  final repository = ref.watch<JobRepository>(jobRepositoryProvider);
  return repository.fetchJob(jobId: id);
});

class JobDetailPage extends ConsumerWidget {
  const JobDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const jobId = 'PYRsrMSOApEgZ6lzMuUK'; //TODO: URLからJobIdを取得する
    return Scaffold(
      appBar: AppBar(
        title: const Text('お手伝い募集'),
      ),
      // Jobの読み込み状態によって表示を変更
      body: ref.watch(jobFutureProvider(jobId)).when(
            data: (job) {
              if (job == null) {
                return const Center(
                  child: Text('お手伝いが存在していません。'),
                );
              }
              // ホストの読み込み状態によってレスポンス
              return ref.watch(hostFutureProvider(job.hostId)).when(
                    data: (host) {
                      if (host == null) {
                        return const Center(
                          child: Text('ホストが存在していません。'),
                        );
                      }
                      return _JobDetail(job: job, host: host);
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
    required this.host,
  });

  final ReadJob job;
  final ReadHost host;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (host.imageUrl.isNotEmpty)
            Center(
              child: LimitedBox(
                maxHeight: 300,
                child: Image.network(host.imageUrl, fit: BoxFit.cover),
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
                // ホスト名 / 仕事タイトル
                Section(
                  title: host.displayName,
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
                // ホスト住所
                Section(
                  title: 'お手伝いの場所',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.place,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),

                // ホスト職種
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
                    enabledItems: host.hostTypes,
                  ),
                ),

                // 内容
                Section(
                  title: '内容',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),

                // 持ち物
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

                // アクセス
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

                // ひとこと
                Section(
                  title: 'ひとこと',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  content: Text(
                    job.comment,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                ),

                // URL
                Section(
                  title: 'URL',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  sectionPadding: const EdgeInsets.only(bottom: 32),
                  content: Column(
                    //TODO: リンクウィジェットにする。
                    children: job.urls
                        .map(
                          (url) => Text(
                            url,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                        .toList(),
                  ),
                ),

                // 体験者の感想
                Section(
                  //TODO: 未実装
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
                onPressed: () => {}, //TODO: 未実装
                child: const Text('このホストに連絡する'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
