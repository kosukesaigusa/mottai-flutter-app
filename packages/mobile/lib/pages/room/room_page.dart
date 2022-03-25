import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/controllers/room/room_page_controller.dart';
import 'package:mottai_flutter_app/providers/message/message_provider.dart';
import 'package:mottai_flutter_app/route/utils.dart';
import 'package:mottai_flutter_app/theme/theme.dart';
import 'package:mottai_flutter_app/utils/utils.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/public_user/public_user.dart';

const double horizontalPadding = 8;
const double partnerImageSize = 36;

class RoomPage extends StatefulHookConsumerWidget {
  const RoomPage({Key? key}) : super(key: key);

  static const path = '/room/';
  static const name = 'RoomPage';

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  @override
  Widget build(BuildContext context) {
    final roomId =
        (ModalRoute.of(context)!.settings.arguments! as RouteArguments)['roomId'] as String;
    return TapToUnfocusWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ref.watch(messagesStreamProvider(roomId)).when<Widget>(
                  loading: () => const SizedBox(),
                  error: (error, stackTrace) {
                    print('=============================');
                    print('⛔️ $error');
                    print(stackTrace);
                    print('=============================');
                    return const SizedBox();
                  },
                  data: (messages) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          if (message.senderId == nonNullUid) {
                            return _buildMessageByMyself(message);
                          } else {
                            return _buildMessageByPartner(message);
                          }
                        },
                        itemCount: messages.length,
                        reverse: true,
                      ),
                    ),
                  ),
                ),
            _buildInputWidget(roomId),
          ],
        ),
      ),
    );
  }

  /// 相手からのメッセージ
  Widget _buildMessageByPartner(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ref.watch(publicUserStreamProvider(message.senderId)).when<Widget>(
                  loading: () => const SizedBox(),
                  error: (error, stackTrace) => const SizedBox(),
                  data: (publicUser) => CircleImage(size: 36, imageURL: publicUser?.imageURL),
                ),
            const Gap(8),
            Container(
              constraints: BoxConstraints(
                maxWidth:
                    (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) *
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
              child: Text(message.body, style: regular12),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 4,
            left: partnerImageSize + horizontalPadding,
            bottom: 16,
          ),
          child: Text(timeString(message.createdAt), style: grey12),
        ),
      ],
    );
  }

  /// 自分からのメッセージ
  Widget _buildMessageByMyself(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth:
                (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) *
                    0.9,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(message.body, style: white12),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 16),
          child: Text(timeString(message.createdAt), style: grey12),
        ),
      ],
    );
  }

  /// 下部の入力欄部分
  Widget _buildInputWidget(String roomId) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: messageBackgroundColor,
            ),
            child: TextField(
              controller: ref.watch(roomPageController(roomId).notifier).textEditingController,
              minLines: 1,
              maxLines: 5,
              style: regular14,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 16,
                  right: 36,
                  top: 8,
                  bottom: 8,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'メッセージを入力',
                hintStyle: regular12,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ref.watch(roomPageController(roomId)).isValid
                ? Theme.of(context).colorScheme.primary
                : grey400,
          ),
          child: GestureDetector(
            onTap: () async {
              if (!ref.read(roomPageController(roomId)).isValid) {
                return;
              }
              await ref.read(roomPageController(roomId).notifier).send();
            },
            child: const Icon(
              Icons.send,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
