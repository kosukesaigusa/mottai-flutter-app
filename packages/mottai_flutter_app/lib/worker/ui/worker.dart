import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../host/ui/create_or_update_host.dart';
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
    final workerImageUrl = ref.watch(workerImageUrlProvider(userId));
    final workerDisplayName = ref.watch(workerDisplayNameProvider(userId));
    final loggedInUserId = ref.watch(userIdProvider);
    final isMatchingUserId = loggedInUserId == userId;
    final isHost = ref.watch(isHostProvider);
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
                    imageUrl: workerImageUrl,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    workerDisplayName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold),
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
                              CreateOrUpdateWorkerPage.location(userId: userId),
                            ),
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              // TODO 自己紹介をDBに追加する
              const Section(
                titleBottomMargin: 4,
                title: '自己紹介',
                content: Text(
                  '''
東京都内に住んでいます。農家さんや漁師さんのお手伝いをすることに興味があります。こんな感じでここには自己紹介文を表示する。表示するのは最大 8 行表くらいでいいだろうか。あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、かきくけこ、さしすせそ、たちつてと、なにぬねの、はひふへほ、まみむめも、やゆよ、わをん、あいうえお、か...''',
                ),
              ),
              const Divider(
                height: 36,
              ),
              // TODO 投稿した感想をDBに追加する
              const Section(
                titleBottomMargin: 4,
                title: '投稿した感想',
                content: MaterialHorizontalCard(
                  title: '矢郷農園でレモンの収穫をお手...あああああああああああああああ',
                  description: '先週末、矢郷農園でレモンの収穫を...あああああああああああ',
                  imageUrl:
                      'https://www.kaku-ichi.co.jp/media/wp-content/uploads/2020/02/20200226001.jpg',
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
                if (!isHost) ...[
                  const Divider(
                    height: 36,
                  ),
                  const Section(
                    titleBottomMargin: 4,
                    title: 'ホストとして登録',
                    content: Text(
                      '''
ホスト（農家、猟師、猟師など）として登録・利用しますか？ホストとして利用すると、自分の農園や仕事の情報を掲載して、お手伝いをしてくれるワーカーとマッチングしますか？''',
                    ),
                  ),
                  Align(
                    child: ElevatedButton(
                      onPressed: () => context.router.pushNamed(
                        CreateOrUpdateHostPage.location(
                          userId: userId,
                          actionType: ActionType.create.name,
                        ),
                      ),
                      child: const Text('ホストとして登録'),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
