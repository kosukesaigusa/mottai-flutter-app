import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../chat/chat_rooms.dart';
import '../../chat/ui/chat_room.dart';
import '../../scaffold_messenger_controller.dart';
import '../../user/host.dart';
import '../../user/user_mode.dart';
import '../job.dart';
import 'job_update.dart';
import 'start_chat_with_host_controller.dart';

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
    final job = ref.watch(jobFutureProvider(jobId)).valueOrNull;
    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('お手伝い募集')),
        body: const Center(child: Text('お手伝い募集の情報が見つかりません。')),
      );
    }
    final isLoading = ref.watch(jobFutureProvider(jobId)).isLoading;
    final hostId = job.hostId;
    return UserAuthDependentBuilder(
      userId: hostId,
      onAuthenticated: (userId, isUserAuthenticated) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('お手伝い募集'),
            actions: [
              if (!isLoading && isUserAuthenticated)
                IconButton(
                  onPressed: () => context.router
                      .pushNamed(JobUpdatePage.location(jobId: jobId)),
                  icon: const Icon(Icons.edit),
                ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ref.watch(hostFutureProvider(job.hostId)).when(
                    data: (readHost) {
                      if (readHost == null) {
                        return const Center(
                          child: Text('ホストが存在しません。'),
                        );
                      }
                      return _JobDetail(job: job, readHost: readHost);
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(
                      child: Text('ホスト情報の取得に失敗しました。'),
                    ),
                  ),
        );
      },
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
            GenericImage.rectangle(imageUrl: readHost.imageUrl),
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
          const Gap(16),
          _StartChatWithHostButton(readHost: readHost),
          const Gap(96),
        ],
      ),
    );
  }
}

class _StartChatWithHostButton extends ConsumerWidget {
  const _StartChatWithHostButton({required this.readHost});

  final ReadHost readHost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHostMode = ref.watch(userModeStateProvider) == UserMode.host;
    final chatRoomExists = ref.watch(chatRoomExistsProvider(readHost.hostId));
    return Column(
      children: [
        Center(
          child: AuthDependentBuilder(
            onAuthenticated: (userId) => Column(
              children: [
                ElevatedButton(
                  onPressed: isHostMode || chatRoomExists
                      ? null
                      : () async {
                          if (isHostMode) {
                            return;
                          }
                          final stackRouter = context.router;
                          final chatRoomId = await ref
                              .read(appScaffoldMessengerControllerProvider)
                              .showDialogByBuilder<String>(
                                builder: (context) => _StartChatWithHostDialog(
                                  hostId: readHost.hostId,
                                  workerId: userId,
                                ),
                                barrierDismissible: false,
                              );
                          if (chatRoomId == null) {
                            return;
                          }
                          stackRouter.popUntilRoot();
                          await stackRouter.pushNamed(
                            ChatRoomPage.location(chatRoomId: chatRoomId),
                          );
                        },
                  child: const Text('このホストに連絡する'),
                ),
                if (isHostMode) ...[
                  const Gap(8),
                  Text(
                    'ホストモードでは、他のホストに連絡することはできません。',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ] else if (chatRoomExists) ...[
                  const Gap(8),
                  Text(
                    'このホストととのチャットルームは既に存在しています。',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
            onUnAuthenticated: () => Column(
              children: [
                const ElevatedButton(
                  onPressed: null,
                  child: Text('このホストに連絡する'),
                ),
                const Gap(8),
                Text(
                  'ホストに連絡するには、ログインが必要です。',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 「このホストに連絡する」を押して、最初のメッセージを送信するダイアログ。
class _StartChatWithHostDialog extends ConsumerStatefulWidget {
  const _StartChatWithHostDialog({
    required this.workerId,
    required this.hostId,
  });

  final String workerId;

  final String hostId;

  @override
  ConsumerState<_StartChatWithHostDialog> createState() =>
      _StartChatWithHostDialogState();
}

class _StartChatWithHostDialogState
    extends ConsumerState<_StartChatWithHostDialog> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ホストへ最初のメッセージ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ホストに最初のメッセージを送りましょう！'
            'メッセージを送ると、チャットルームが作成されます。',
          ),
          const Gap(16),
          TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'メッセージ',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            final chatRoomId =
                await ref.read(startChatControllerProvider).startChatWithHost(
                      workerId: widget.workerId,
                      hostId: widget.hostId,
                      content: _textEditingController.text,
                    );
            if (chatRoomId == null) {
              return;
            }
            if (mounted) {
              Navigator.pop(context, chatRoomId);
            }
          },
          child: const Text('送信'),
        ),
      ],
    );
  }
}
