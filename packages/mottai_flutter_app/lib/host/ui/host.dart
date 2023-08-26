import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../job/job.dart';
import '../../user/host.dart';
import '../../user/ui/user_mode.dart';
import '../../user/user_mode.dart';
import 'create_or_update_host.dart';

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
      // TODO: マイアカウントページで AppBar が二重にならないように対応する。
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
    final hostImageUrl = ref.watch(hostImageUrlProvider(userId));
    final hostDisplayName = ref.watch(hostDisplayNameProvider(userId));
    final readHost = ref.watch(hostFutureProvider(userId));
    final currentUserMode = ref.watch(userModeStateProvider);
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
                  imageUrl: hostImageUrl,
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    hostDisplayName,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                UserAuthDependentBuilder(
                  onUserAuthenticated: (userId) {
                    return CircleAvatar(
                      backgroundColor: Theme.of(context).focusColor,
                      child: IconButton(
                        color: Theme.of(context).shadowColor,
                        onPressed: () => context.router.pushNamed(
                          CreateOrUpdateHostPage.location(
                            userId: userId,
                            actionType: ActionType.update.name,
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                      ),
                    );
                  },
                  userId: userId,
                ),
              ],
            ),
            UserAuthDependentBuilder(
              userId: userId,
              onUserAuthenticated: (_) {
                return Column(
                  children: [
                    const Gap(16),
                    UserModeSection(userId: userId),
                  ],
                );
              },
            ),
            const Gap(24),
            // TODO 自己紹介をDBに追加する
            Section(
              title: '自己紹介',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              titleBottomMargin: 8,
              content: const Text(
                '''
神奈川県小田原市で農家や漁師をしています。夏の時期にレモンの収穫のお手伝いをしてくれる方を募集しています。こんな感じでここには自己紹介文を表示する。表示するのは最大 8 行表くらいでいいだろうか。あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ...''',
              ),
            ),
            const Gap(24),
            Section(
              title: 'ホストタイプ',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              titleBottomMargin: 8,
              content: const Text('ワーカーはホストタイプ（複数選択可）を参考にして、興味のあるお手伝いを探します。'),
            ),
            readHost.when(
              data: (readHost) {
                if (readHost == null) {
                  return const Center(
                    child: Text('ホストタイプがありません。'),
                  );
                }
                return SelectableChips<HostType>(
                  allItems: HostType.values,
                  labels: Map.fromEntries(
                    HostType.values.map(
                      (type) => MapEntry(type, type.label),
                    ),
                  ),
                  enabledItems: readHost.hostTypes,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const Center(
                child: Text('通信に失敗しました。'),
              ),
            ),
            const Gap(24),
            Section(
              title: '公開する場所・住所',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              titleBottomMargin: 8,
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('''
農場や主な作業場所などの、公開される場所・住所です。ワーカーは地図上から近所や興味がある地域のホストを探します。必ずしも正確で細かい住所である必要はありません。'''),
                  Gap(12),
                  // TODO ここは後でデータを取得する
                  Text('神奈川県小田原市石322 (hostLocation.address)'),
                ],
              ),
            ),
            UserModeSection(userId: userId),
            const Gap(24),
            // TODO 自己紹介をDBに追加する
            const Section(
              titleBottomMargin: 4,
              title: '自己紹介',
              content: Text(
                '''
神奈川県小田原市で農家や漁師をしています。夏の時期にレモンの収穫のお手伝いをしてくれる方を募集しています。こんな感じでここには自己紹介文を表示する。表示するのは最大 8 行表くらいでいいだろうか。あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ...''',
              ),
            ),
            const Gap(24),
            const Section(
              titleBottomMargin: 4,
              title: 'ホストタイプ',
              content: Text('ワーカーはホストタイプ（複数選択可）を参考にして、興味のあるお手伝いを探します。'),
            ),
            readHost.when(
              data: (readHost) {
                if (readHost == null) {
                  return const Center(
                    child: Text('ホストタイプがありません。'),
                  );
                }
                return SelectableChips<HostType>(
                  allItems: HostType.values,
                  labels: Map.fromEntries(
                    HostType.values.map(
                      (type) => MapEntry(type, type.label),
                    ),
                  ),
                  enabledItems: readHost.hostTypes,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const Center(
                child: Text('通信に失敗しました。'),
              ),
            ),
            const Gap(24),
            const Section(
              titleBottomMargin: 4,
              title: '公開する場所・住所',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('''
農場や主な作業場所などの、公開される場所・住所です。ワーカーは地図上から近所や興味がある地域のホストを探します。必ずしも正確で細かい住所である必要はありません。'''),
                  Gap(12),
                  // TODO ここは後でデータを取得する
                  Text('神奈川県小田原市石322 (hostLocation.address)'),
                ],
              ),
            ),
            const Divider(
              height: 36,
            ),
            Section(
              titleBottomMargin: 4,
              title: '掲載中のお手伝い募集',
              content: ref.watch(userJobsFutureProvider(userId)).when(
                    data: (jobs) {
                      if (jobs.isEmpty) {
                        return const Center(
                          child: Text('掲載中のお手伝いがありません。'),
                        );
                      }
                      final list_ = jobs.map(
                        (job) {
                          return MaterialHorizontalCard(
                            title: job.title,
                            description: job.content,
                            // TODO 掲載中のお仕事ごとに画像があってもいいかも
                            imageUrl:
                                'https://image.space.rakuten.co.jp/d/strg/ctrl/9/640594311698c5a7d384759ef33cd4c313b50f29.96.9.9.3.jpeg',
                          );
                        },
                      ).toList();
                      return Column(
                        children: list_,
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => const Center(
                      child: Text('通信に失敗しました。'),
                    ),
                  ),
            ),
            UserAuthDependentBuilder(
              userId: userId,
              onUserAuthenticated: (_) {
                return Column(
                  children: [
                    const Divider(height: 36),
                    Section(
                      title: 'ソーシャル連携',
                      titleStyle: Theme.of(context).textTheme.titleLarge,
                      content: const Column(
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                size: 30,
                              ),
                              Gap(10),
                              Text('Google'),
                              // TODO google連携済みかどうかで出し分けられるようにする
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('連携済み'),
                                ),
                              ),
                            ],
                          ),
                          Gap(12),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.apple,
                                size: 40,
                              ),
                              Gap(10),
                              Text('Apple'),
                              // TODO apple連携済みかどうかで出し分けられるようにする
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('連携済み'),
                                ),
                              ),
                            ],
                          ),
                          Gap(12),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.line,
                                color: Color(0xff06c755),
                                size: 30,
                              ),
                              Gap(10),
                              Text('LINE'),
                              // TODO line連携済みかどうかで出し分けられるようにする
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('連携済み'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
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
