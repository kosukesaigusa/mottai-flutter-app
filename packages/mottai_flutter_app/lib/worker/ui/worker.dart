import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../auth/ui/social_link_buttons.dart';
import '../../host/ui/host_create.dart';
import '../../user/ui/user_mode.dart';
import '../../user/user.dart';
import '../../user/worker.dart';
import 'create_or_update_worker.dart';

/// ワーカーページ。
@RoutePage()
class WorkerPage extends ConsumerWidget {
  const WorkerPage({
    @PathParam('userId') required this.userId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/worker/:userId';

  /// [WorkerPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String userId}) => '/worker/$userId';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ワーカー')),
      body: WorkerPageBody(userId: userId),
    );
  }
}

/// [WorkerPage] のコンテンツ。マイアカウントページでは、[WorkerPageBody] のみを共通
/// コンポーネントとして利用するためこのように分離している。
class WorkerPageBody extends ConsumerWidget {
  const WorkerPageBody({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(workerStreamProvider(userId)).when(
          data: (worker) {
            if (worker == null) {
              return const Center(child: Text('ワーカーが見つかりません。'));
            }
            return UserAuthDependentBuilder(
              userId: userId,
              onAuthenticated: (userId, isUserAuthenticated) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            GenericImage.circle(imageUrl: worker.imageUrl),
                            if (worker.displayName.isNotEmpty) ...[
                              const Gap(16),
                              Expanded(
                                child: Text(
                                  worker.displayName,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            if (isUserAuthenticated)
                              CircleAvatar(
                                backgroundColor: Theme.of(context).focusColor,
                                child: IconButton(
                                  color: Theme.of(context).shadowColor,
                                  onPressed: () => context.router.pushNamed(
                                    CreateOrUpdateWorkerPage.location(
                                      userId: userId,
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Gap(32),
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
                          titleBottomMargin: 8,
                          title: '自己紹介',
                          titleStyle: Theme.of(context).textTheme.titleLarge,
                          content: Text(
                            worker.introduction.ifIsEmpty('自己紹介が登録されていません。'),
                          ),
                        ),
                      ),
                      const Gap(32),
                      const Divider(height: 48),
                      // TODO 投稿した感想をDBに追加する
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Section(
                          titleBottomMargin: 8,
                          title: '投稿した感想',
                          titleStyle: Theme.of(context).textTheme.titleLarge,
                          content: const MaterialHorizontalCard(
                            header: '矢郷農園でレモンの収穫をお手...あああああああああああああああ',
                            subhead: '先週末、矢郷農園でレモンの収穫を...あああああああああああ',
                            mediaImageUrl:
                                'https://www.kaku-ichi.co.jp/media/wp-content/uploads/2020/02/20200226001.jpg',
                          ),
                        ),
                      ),
                      const Divider(height: 48),
                      if (isUserAuthenticated)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Section(
                            title: 'ソーシャル連携',
                            titleStyle: Theme.of(context).textTheme.titleLarge,
                            content: const SocialLinkButtons(),
                          ),
                        ),
                      const Divider(height: 48),
                      if (isUserAuthenticated &&
                          !ref.watch(isCurrentUserHostProvider)) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Section(
                            title: 'ホストとして登録',
                            titleStyle: Theme.of(context).textTheme.titleLarge,
                            titleBottomMargin: 8,
                            content: const Text(
                              'ホスト（農家、猟師、猟師など）として登録・利用しますか？'
                              'ホストとして利用すると、自分の農園や仕事の情報を掲載して、'
                              'お手伝いをしてくれるワーカーとマッチングしますか？',
                            ),
                          ),
                        ),
                        const Gap(16),
                        Align(
                          child: ElevatedButton(
                            onPressed: () => context.router.pushNamed(
                              HostCreatePage.location,
                            ),
                            child: const Text('ホストとして登録'),
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
