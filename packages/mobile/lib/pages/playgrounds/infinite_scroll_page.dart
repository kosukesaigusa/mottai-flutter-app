import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../constants/style.dart';
import '../../features/playgrounds/playground_message/playground_message_providers.dart';
import '../../utils/date_time.dart';
import '../../utils/extensions/build_context.dart';
import '../../utils/utils.dart';
import '../../widgets/image.dart';

const double horizontalPadding = 8;
const double partnerImageSize = 36;

/// 無限スクロールの練習ページ
class InfiniteScrollPage extends StatefulHookConsumerWidget {
  const InfiniteScrollPage({super.key});

  static const path = '/infinite-scroll';
  static const name = 'InfiniteScrollPage';
  static const location = path;

  @override
  ConsumerState<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends ConsumerState<InfiniteScrollPage> {
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(playgroundMessageStateNotifierProvider.select((s) => s.messages));
    return Scaffold(
      appBar: AppBar(title: Text('現在の表示件数：$_count 件')),
      body: ref.watch(playgroundMessageStateNotifierProvider).loading
          ? const Center(
              child: FaIcon(
                FontAwesomeIcons.solidComment,
                size: 72,
                color: Colors.black12,
              ),
            )
          : ListView.builder(
              controller:
                  ref.watch(playgroundMessageStateNotifierProvider.notifier).scrollController,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showDate(
                        itemCount: messages.length,
                        index: index,
                        messages: messages,
                      ))
                        ..._dateWidget(message),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleImageWidget(
                            diameter: 36,
                            imageURL: 'https://full-count.jp/wp-content/uploads/'
                                '2022/03/22062924/20220322_ohtani4_ap-560x373.jpg',
                          ),
                          const Gap(8),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: (MediaQuery.of(context).size.width -
                                      partnerImageSize -
                                      horizontalPadding * 3) *
                                  0.9,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: messageBackgroundColor,
                            ),
                            child: Text(message.body, style: context.bodySmall),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: partnerImageSize + horizontalPadding,
                          bottom: 16,
                        ),
                        child: Text(
                          to24HourNotationString(message.createdAt.dateTime),
                          style: context.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: messages.length,
              reverse: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final playgroundMessageId = uuid;
          await ref
              .read(playgroundMessageRepositoryProvider)
              .playgroundMessageRef(playgroundMessageId: playgroundMessageId)
              .set(
                PlaygroundMessage(
                  playgroundMessageId: playgroundMessageId,
                  body: '$uuid-$uuid',
                ),
              );
        },
        child: const FaIcon(FontAwesomeIcons.solidComment),
      ),
    );
  }

  /// AppBar に表示する現在の取得メッセージ数
  int get _count =>
      ref.watch(playgroundMessageStateNotifierProvider.select((s) => s.messages)).length;

  /// 各メッセージの上に日付を表示するかどうか
  bool _showDate({
    required int itemCount,
    required int index,
    required List<PlaygroundMessage> messages,
  }) {
    if (itemCount == 1) {
      return true;
    }
    if (index == itemCount - 1) {
      return true;
    }
    final lastCreatedAt = messages[index].createdAt.dateTime;
    final previouslyCreatedAt = messages[index + 1].createdAt.dateTime;
    if (lastCreatedAt == null || previouslyCreatedAt == null) {
      return false;
    }
    if (sameDay(lastCreatedAt, previouslyCreatedAt)) {
      return false;
    }
    return true;
  }

  /// 各メッセージの上に表示する日付
  List<Widget> _dateWidget(PlaygroundMessage message) {
    return [
      const Gap(24),
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: messageBackgroundColor,
          ),
          child: Text(
            toIsoStringDateWithWeekDay(message.createdAt.dateTime),
            style: context.bodySmall,
          ),
        ),
      ),
      const Gap(24),
    ];
  }
}
