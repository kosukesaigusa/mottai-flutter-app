import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../auth/ui/social_link_buttons.dart';
import '../../host_location/host_location.dart';
import '../../job/job.dart';
import '../../user/host.dart';
import '../../user/ui/user_mode.dart';
import 'host_update.dart';

/// ホストページ。
@RoutePage()
class HostPage extends ConsumerWidget {
  const HostPage({
    @PathParam('userId') required this.userId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/host/:userId';

  /// [HostPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String userId}) => '/host/$userId';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホスト')),
      body: HostPageBody(userId: userId),
    );
  }
}

/// [HostPage] のコンテンツ。マイアカウントページでは、[HostPageBody] のみを共通
/// コンポーネントとして利用するためこのように分離している。
class HostPageBody extends ConsumerWidget {
  const HostPageBody({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(hostStreamProvider(userId)).when(
          data: (host) {
            if (host == null) {
              return const Center(child: Text('ホストが見つかりません。'));
            }
            return UserAuthDependentBuilder(
              userId: userId,
              onAuthenticated: (userId, isUserAuthenticated) {
                final hostLocation =
                    ref.watch(hostLocationStreamProvider(userId)).valueOrNull;
                final jobs =
                    ref.watch(userJobsStreamProvider(userId)).value ?? [];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            GenericImage.circle(imageUrl: host.imageUrl),
                            const Gap(16),
                            Expanded(
                              child: Text(
                                host.displayName,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUserAuthenticated)
                              CircleAvatar(
                                backgroundColor: Theme.of(context).focusColor,
                                child: IconButton(
                                  color: Theme.of(context).shadowColor,
                                  onPressed: () => context.router.pushNamed(
                                    HostUpdatePage.location(hostId: userId),
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isUserAuthenticated) ...[
                        const Gap(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: UserModeSection(userId: userId),
                        ),
                      ],
                      const Gap(32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Section(
                          title: '自己紹介',
                          titleStyle: Theme.of(context).textTheme.titleLarge,
                          titleBottomMargin: 8,
                          content: Text(
                            host.introduction.ifIsEmpty('自己紹介が登録されていません。'),
                          ),
                        ),
                      ),
                      const Gap(24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Section(
                          title: 'ホストタイプ',
                          titleStyle: Theme.of(context).textTheme.titleLarge,
                          titleBottomMargin: 8,
                          content: const Text(
                            'ワーカーはホストタイプ（複数選択可）を参考にして、'
                            '興味のあるお手伝いを探します。',
                          ),
                        ),
                      ),
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SelectableChips<HostType>(
                          allItems: HostType.values,
                          labels: Map.fromEntries(
                            HostType.values
                                .map((type) => MapEntry(type, type.label)),
                          ),
                          enabledItems: host.hostTypes,
                        ),
                      ),
                      const Gap(32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Section(
                          title: '公開する場所・住所',
                          titleStyle: Theme.of(context).textTheme.titleLarge,
                          titleBottomMargin: 8,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '農場や主な作業場所などの、公開される場所・住所です。'
                                'ワーカーは地図上から近所や興味がある地域のホストを探します。'
                                '必ずしも正確で細かい住所である必要はありません。',
                              ),
                              const Gap(8),
                              if (hostLocation != null)
                                Text(
                                  hostLocation.address
                                      .ifIsEmpty('お手伝いの場所が登録されていません'),
                                )
                              else
                                const Text('お手伝いの場所が登録されていません')
                            ],
                          ),
                        ),
                      ),
                      const Gap(32),
                      if (jobs.isNotEmpty) ...[
                        const Divider(height: 48),
                        for (final job in jobs)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Section(
                              titleBottomMargin: 8,
                              title: '掲載中のお手伝い募集',
                              titleStyle:
                                  Theme.of(context).textTheme.titleLarge,
                              content: MaterialHorizontalCard(
                                header: job.title,
                                subhead: job.content,
                                mediaImageUrl: job.imageUrl,
                              ),
                            ),
                          ),
                      ],
                      if (isUserAuthenticated) ...[
                        const Divider(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Section(
                            title: 'ソーシャル連携',
                            titleStyle: Theme.of(context).textTheme.titleLarge,
                            content: const SocialLinkButtons(),
                          ),
                        ),
                      ],
                      const Gap(32),
                    ],
                  ),
                );
              },
            );
          },
          error: (_, __) => const SizedBox(),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
