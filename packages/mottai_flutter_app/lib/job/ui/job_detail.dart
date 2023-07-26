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
        centerTitle: true,
      ),
      // Jobの読み込み状態によって表示を変更
      body: ref.watch(jobFutureProvider(jobId)).when(
            data: (job) {
              if (job == null) {
                return _buildErrorPage('お手伝いが存在していません。');
              }
              // ホストの読み込み状態によってレスポンス
              return ref.watch(hostFutureProvider(job.hostId)).when(
                    data: (host) {
                      if (host == null) {
                        return _buildErrorPage('ホストが存在していません。');
                      }
                      return _buildJobPage(context, job, host, ref);
                    },
                    loading: _buildLoadingPage,
                    error: (error, stackTrace) => _buildErrorPage('通信に失敗しました。'),
                  );
            },
            loading: _buildLoadingPage,
            error: (error, stackTrace) => _buildErrorPage('通信に失敗しました。'),
          ),
    );
  }

  Widget _buildErrorPage(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _buildLoadingPage() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildJobPage(
    BuildContext context,
    ReadJob job,
    ReadHost host,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (host.imageUrl != '')
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
                _buildSection(
                  title: host.displayName,
                  content: job.title,
                  titleStyle: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  contentStyle: Theme.of(context).textTheme.bodyMedium,
                  contentMaxLines: 2,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),
                // ホスト住所
                _buildSection(
                  title: 'お手伝いの場所',
                  content: job.place,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.titleMedium,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),

                // ホスト職種
                _buildSection(
                  title: 'ホスト',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                  contentWidget: Row(
                    children: _buildHostTypeChips(host.hostTypes),
                  ),
                ),

                // 内容
                _buildSection(
                  title: '内容',
                  content: job.content,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),

                // 持ち物
                _buildSection(
                  title: '持ち物',
                  content: job.belongings,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),

                // 報酬
                _buildSection(
                  title: '報酬',
                  content: job.reward,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),

                // アクセス
                _buildSection(
                  title: 'アクセス',
                  content: job.accessDescription,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                  contentWidget: Wrap(
                    children: _buildAccessTypeChips(job.accessTypes),
                  ),
                ),

                // ひとこと
                _buildSection(
                  title: 'ひとこと',
                  content: job.comment,
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                ),

                // URL
                _buildSection(
                  title: 'URL',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
                  contentWidget: Column(
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
                _buildSection(
                  //TODO: 未実装
                  title: '体験者の感想',
                  content: '仮',
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  contentStyle: Theme.of(context).textTheme.bodyLarge,
                  sectionPadding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildSection({
    required String title,
    String? content,
    EdgeInsetsGeometry? sectionPadding,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    int? contentMaxLines,
    Widget? contentWidget,
  }) {
    return Padding(
      padding: sectionPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
            maxLines: 1,
          ),
          const SizedBox(
            height: 8,
          ),
          if (content != null)
            Text(
              content,
              style: contentStyle,
              maxLines: contentMaxLines,
            ),
          if (contentWidget != null) contentWidget,
        ],
      ),
    );
  }

  List<Widget> _buildHostTypeChips(
    Set<HostType> hostTypes,
  ) {
    final chipList = <Widget>[];

    for (final type in HostType.values) {
      chipList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SwitchingChip(
            label: type.label,
            isEnabled: hostTypes.contains(type),
          ),
        ),
      );
    }
    return chipList;
  }

  List<Widget> _buildAccessTypeChips(
    Set<AccessType> accessTypes,
  ) {
    final chipList = <Widget>[];
    for (final type in AccessType.values) {
      if (accessTypes.contains(type)) {
        chipList.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SwitchingChip(
              label: type.label,
              isEnabled: true,
            ),
          ),
        );
      }
    }
    return chipList;
  }
}
