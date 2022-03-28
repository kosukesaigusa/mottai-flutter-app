import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/providers/providers.dart';
import 'package:mottai_flutter_app/widgets/common/loading.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../theme/theme.dart';
import '../../utils/utils.dart';

const double horizontalPadding = 8;
const double partnerImageSize = 36;

class InfiniteScrollPage extends StatefulHookConsumerWidget {
  const InfiniteScrollPage({Key? key}) : super(key: key);

  static const path = '/infinite-scroll/';
  static const name = 'InfiniteScrollPage';

  @override
  ConsumerState<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends ConsumerState<InfiniteScrollPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 無限スクロール')),
      body: ref.watch(playgroundMessagesStreamProvider).when<Widget>(
            data: (playgroundMessages) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final playgroundMessage = playgroundMessages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleImage(
                            size: 36,
                            imageURL:
                                'https://full-count.jp/wp-content/uploads/2022/03/22062924/20220322_ohtani4_ap-560x373.jpg',
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
                            child: Text(playgroundMessage.body, style: regular12),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: partnerImageSize + horizontalPadding,
                          bottom: 16,
                        ),
                        child: Text(timeString(playgroundMessage.createdAt), style: grey12),
                      ),
                    ],
                  );
                },
                itemCount: playgroundMessages.length,
                reverse: true,
              ),
            ),
            error: (_, __) => const Text('error'),
            loading: () => const PrimarySpinkitCircle(),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final playgroundMessageId = uuid;
          await PlaygroundMessageRepository.playgroundMessageRef(
                  playgroundMessageId: playgroundMessageId)
              .set(PlaygroundMessage(
            playgroundMessageId: playgroundMessageId,
            body: '$uuid-$uuid',
          ));
        },
        child: const FaIcon(FontAwesomeIcons.solidComment),
      ),
    );
  }
}
