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
    final workerImageUrl = ref.watch(workerImageUrlProvider(userId));
    final workerDisplayName = ref.watch(workerDisplayNameProvider(userId));
    final isHost = ref.watch(isHostProvider);
    return SingleChildScrollView(
      // TODO: Divider は横いっぱいに表示したいので Padding の水平方向の全体適用はやめたい。
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GenericImage.circle(
                  imageUrl: workerImageUrl,
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    workerDisplayName,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                UserAuthDependentBuilder(
                  userId: userId,
                  onAuthenticated: (_, isUserAuthenticated) {
                    if (isUserAuthenticated) {
                      return const SizedBox();
                    }
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).focusColor,
                      child: IconButton(
                        color: Theme.of(context).shadowColor,
                        onPressed: () => context.router.pushNamed(
                          CreateOrUpdateWorkerPage.location(userId: userId),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                    );
                  },
                ),
              ],
            ),
            UserAuthDependentBuilder(
              userId: userId,
              onAuthenticated: (userId, isUserAuthenticated) {
                if (!isUserAuthenticated) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    const Gap(16),
                    UserModeSection(userId: userId),
                  ],
                );
              },
            ),
            const Gap(16),
            // TODO 自己紹介をDBに追加する
            Section(
              titleBottomMargin: 8,
              title: '自己紹介',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              content: const Text(
                '''
東京都内に住んでいます。農家さんや漁師さんのお手伝いをすることに興味があります。こんな感じでここには自己紹介文を表示する。表示するのは最大 8 行表くらいでいいだろうか。あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、か...''',
              ),
            ),
            const Divider(
              height: 36,
            ),
            // TODO 投稿した感想をDBに追加する
            Section(
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
            UserAuthDependentBuilder(
              userId: userId,
              onAuthenticated: (_, isUserAuthenticated) {
                if (!isUserAuthenticated) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    const Divider(height: 36),
                    Section(
                      title: 'ソーシャル連携',
                      titleStyle: Theme.of(context).textTheme.titleLarge,
                      content: const SocialLinkButtons(),
                    ),
                    if (!isHost) ...[
                      const Divider(height: 36),
                      Section(
                        title: 'ホストとして登録',
                        titleStyle: Theme.of(context).textTheme.titleLarge,
                        titleBottomMargin: 8,
                        content: const Text(
                          '''
ホスト（農家、猟師、猟師など）として登録・利用しますか？ホストとして利用すると、自分の農園や仕事の情報を掲載して、お手伝いをしてくれるワーカーとマッチングしますか？''',
                        ),
                      ),
                      Align(
                        child: ElevatedButton(
                          onPressed: () => context.router.pushNamed(
                            HostCreatePage.location,
                          ),
                          child: const Text('ホストとして登録'),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}
