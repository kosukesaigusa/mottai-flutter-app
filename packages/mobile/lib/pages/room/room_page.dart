import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/auth/auth_providers.dart';
import '../../providers/public_user/public_user_providers.dart';
import '../../providers/read_status/read_status_providers.dart';
import '../../providers/room/room_providers.dart';
import '../../route/utils.dart';
import '../../theme/theme.dart';
import '../../utils/enums.dart';

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
    final userId = ref.watch(userIdProvider).value;
    // TODO: 他の画面を表示するべき？
    if (userId == null) {
      return const SizedBox();
    }
    final messages = ref.watch(roomPageStateNotifierProvider(roomId).select((s) => s.messages));
    return TapToUnfocusWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: ref.watch(roomPageStateNotifierProvider(roomId)).loading
            ? const Center(
                child: FaIcon(
                  FontAwesomeIcons.solidComment,
                  size: 72,
                  color: Colors.black12,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        controller: ref
                            .watch(roomPageStateNotifierProvider(roomId).notifier)
                            .scrollController,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageWidget(
                            roomId: roomId,
                            message: message,
                            showDate: _showDate(
                              itemCount: messages.length,
                              index: index,
                              messages: messages,
                            ),
                            senderType:
                                message.senderId == userId ? SenderType.myself : SenderType.partner,
                          );
                        },
                        itemCount: messages.length,
                        reverse: true,
                      ),
                    ),
                  ),
                  RoomMessageInputWidget(roomId: roomId),
                ],
              ),
      ),
    );
  }

  /// 日付を表示するかどうか
  bool _showDate({required int itemCount, required int index, required List<Message> messages}) {
    if (itemCount == 1) {
      return true;
    }
    if (index == itemCount - 1) {
      return true;
    }
    final lastCreatedAt = messages[index].createdAt;
    final previouslyCreatedAt = messages[index + 1].createdAt;
    if (lastCreatedAt == null || previouslyCreatedAt == null) {
      return false;
    }
    if (sameDay(lastCreatedAt, previouslyCreatedAt)) {
      return false;
    }
    return true;
  }
}

/// メッセージ、日付、相手のアイコン、送信日時のウィジェット
class MessageWidget extends HookConsumerWidget {
  const MessageWidget({
    Key? key,
    required this.roomId,
    required this.message,
    required this.showDate,
    required this.senderType,
  }) : super(key: key);

  final String roomId;
  final Message message;
  final bool showDate;
  final SenderType senderType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment:
          senderType == SenderType.myself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showDate) ..._dateWidget(message),
        Row(
          mainAxisAlignment:
              senderType == SenderType.myself ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (senderType == SenderType.partner) ...[
              ref.watch(publicUserStreamProvider(message.senderId)).when<Widget>(
                    loading: () => const SizedBox(),
                    error: (error, stackTrace) => const SizedBox(),
                    data: (publicUser) => CircleImage(size: 36, imageURL: publicUser?.imageURL),
                  ),
              const Gap(8),
            ],
            Container(
              constraints: BoxConstraints(
                maxWidth:
                    (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) *
                        0.9,
              ),
              padding: const EdgeInsets.all(12),
              decoration: senderType == SenderType.myself
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: messageBackgroundColor,
                    ),
              child: Text(
                message.body,
                style: senderType == SenderType.myself ? white12 : regular12,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4,
            left: senderType == SenderType.myself ? 0 : partnerImageSize + horizontalPadding,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment:
                senderType == SenderType.myself ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(to24HourNotationString(message.createdAt), style: grey10),
              if (senderType == SenderType.myself)
                SizedBox(
                  height: 14,
                  child: ref.watch(partnerReadStatusStreamProvider(roomId)).when(
                        data: (readStatus) => Text(
                          _read(message: message, lastReadAt: readStatus?.lastReadAt) ? '既読' : '未読',
                          style: grey10,
                        ),
                        error: (_, __) => const SizedBox(),
                        loading: () => const SizedBox(),
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// 表示する日付
  List<Widget> _dateWidget(Message message) {
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
            toIsoStringDateWithWeekDay(message.createdAt),
            style: grey10,
          ),
        ),
      ),
      const Gap(24),
    ];
  }

  /// Message.createdAt と 最後に読んだ日を比較して既読かどうかを返す
  bool _read({required Message message, required DateTime? lastReadAt}) {
    final createdAt = message.createdAt;
    if (createdAt == null || lastReadAt == null) {
      return false;
    }
    return lastReadAt.isAfter(createdAt);
  }
}

/// ルームページのメッセージ入力欄のウィジェット
class RoomMessageInputWidget extends HookConsumerWidget {
  const RoomMessageInputWidget({Key? key, required this.roomId}) : super(key: key);
  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              controller:
                  ref.watch(roomPageStateNotifierProvider(roomId).notifier).textEditingController,
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
        GestureDetector(
          onTap: () async {
            if (!ref.read(roomPageStateNotifierProvider(roomId)).isValid) {
              return;
            }
            await ref.read(roomPageStateNotifierProvider(roomId).notifier).send();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ref.watch(roomPageStateNotifierProvider(roomId)).isValid
                  ? Theme.of(context).colorScheme.primary
                  : grey400,
            ),
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
