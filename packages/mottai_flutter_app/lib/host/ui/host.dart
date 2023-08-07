import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../user/host.dart';
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
    final hostImageUrl = ref.watch(hostImageUrlProvider(userId));
    final hostDisplayName = ref.watch(hostDisplayNameProvider(userId));
    final loggedInUserId = ref.watch(userIdProvider);
    final isMatchingUserId = loggedInUserId == userId;
    final readHost = ref.watch(hostFutureProvider(userId));
    final currentUserMode = ref.watch(userModeStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GenericImage.circle(
                    imageUrl: hostImageUrl,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    hostDisplayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (isMatchingUserId)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).focusColor,
                          child: IconButton(
                            color: Theme.of(context).shadowColor,
                            onPressed: () => context.router.pushNamed(
                              CreateOrUpdateHostPage.location(userId: userId),
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (isMatchingUserId) ...[
                const SizedBox(
                  height: 12,
                ),
                Section(
                  title: 'ユーザーモード',
                  content: Text(
                    currentUserMode == UserMode.host
                        ? '''
ホストとしてアプリを使用します。あなたが募集するお手伝いに興味があるワーカーとやりとりをして、お手伝いを受け入れるモードです。'''
                        : 'ワーカーとしてアプリを使用します。興味のあるホストやお手伝いを探して、お手伝いに応募するモードです。',
                  ),
                ),
                SegmentedButton<UserMode>(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  segments: const <ButtonSegment<UserMode>>[
                    ButtonSegment<UserMode>(
                      value: UserMode.host,
                      label: Text('ホスト'),
                    ),
                    ButtonSegment<UserMode>(
                      value: UserMode.worker,
                      label: Text('ワーカー'),
                    ),
                  ],
                  selected: <UserMode>{currentUserMode},
                  onSelectionChanged: (newSelection) {
                    ref
                        .read(userModeStateProvider.notifier)
                        .update((_) => newSelection.first);
                  },
                ),
              ],
              const SizedBox(height: 12),
              // TODO 自己紹介をDBに追加する
              const Section(
                title: '自己紹介',
                content: Text(
                  '''
神奈川県小田原市で農家や漁師をしています。夏の時期にレモンの収穫のお手伝いをしてくれる方を募集しています。こんな感じでここには自己紹介文を表示する。表示するのは最大 8 行表くらいでいいだろうか。あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ...''',
                ),
              ),
              const SizedBox(height: 12),
              const Section(
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
              const SizedBox(height: 12),
              const Section(
                title: '公開する場所・住所',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('''
農場や主な作業場所などの、公開される場所・住所です。ワーカーは地図上から近所や興味がある地域のホストを探します。必ずしも正確で細かい住所である必要はありません。'''),
                    SizedBox(height: 12),
                    // TODO ここは後でデータを取得する
                    Text('神奈川県小田原市石322 (hostLocation.address)'),
                  ],
                ),
              ),
              const Divider(
                height: 36,
              ),
              // TODO 掲載中のお手伝いを取得する
              const Section(
                title: '掲載中のお手伝い募集',
                content: MaterialHorizontalCard(
                  title: '仕事のタイトル',
                  description: 'みかんの収穫や、その他、農作業全...',
                  imageUrl:
                      'https://image.space.rakuten.co.jp/d/strg/ctrl/9/640594311698c5a7d384759ef33cd4c313b50f29.96.9.9.3.jpeg',
                ),
              ),
              if (isMatchingUserId) ...[
                const Divider(
                  height: 36,
                ),
                const Section(
                  title: 'ソーシャル連携',
                  content: Column(
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.google,
                            size: 30,
                          ),
                          SizedBox(width: 10),
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
                      SizedBox(height: 12),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.apple,
                            size: 40,
                          ),
                          SizedBox(width: 10),
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
                      SizedBox(height: 12),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.line,
                            color: Color(0xff06c755),
                            size: 30,
                          ),
                          SizedBox(width: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
