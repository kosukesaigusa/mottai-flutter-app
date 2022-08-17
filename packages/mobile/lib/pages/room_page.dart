import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../constants/style.dart';
import '../providers/auth/auth.dart';
import '../providers/public_user/public_user_providers.dart';
import '../providers/read_status/read_status_providers.dart';
import '../providers/room/room_providers.dart';
import '../route/app_router_state.dart';
import '../utils/date_time.dart';
import '../utils/exceptions/base.dart';
import '../utils/extensions/build_context.dart';
import '../widgets/common/image.dart';

final _roomIdProvider = Provider.autoDispose<String>(
  (ref) {
    final state = ref.watch(appRouterStateProvider);
    final roomId = state.params['roomId'];
    if (roomId == null) {
      throw const AppException(message: 'チャットルームが見つかりませんでした。');
    }
    return roomId;
  },
  dependencies: [
    extractExtraDataProvider,
    appRouterStateProvider,
  ],
);

const double horizontalPadding = 8;
const double partnerImageSize = 36;

/// チャットルームページ
class RoomPage extends StatefulHookConsumerWidget {
  const RoomPage({super.key});

  static const path = '/room/:roomId';
  static const name = 'RoomPage';
  static String location({required String roomId}) => '/room/$roomId';

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(_roomIdProvider);
    final messages = ref.watch(roomPageStateNotifierProvider(roomId).select((s) => s.messages));
    final userId = ref.watch(userIdProvider).value;
    return Scaffold(
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
                        return MessageItemWidget(
                          roomId: roomId,
                          message: message,
                          showDate: _showDate(
                            itemCount: messages.length,
                            index: index,
                            messages: messages,
                          ),
                          isMyMessage: message.senderId == userId,
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
    );
  }

  /// 日付を表示するかどうか
  bool _showDate({
    required int itemCount,
    required int index,
    required List<Message> messages,
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
}

/// メッセージ、日付、相手のアイコン、送信日時のウィジェット
class MessageItemWidget extends HookConsumerWidget {
  const MessageItemWidget({
    super.key,
    required this.roomId,
    required this.message,
    required this.showDate,
    required this.isMyMessage,
  });

  final String roomId;
  final Message message;
  final bool showDate;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (showDate) DateOnChatRoomWidget(dateTime: message.createdAt.dateTime),
        Row(
          mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMyMessage) ...[
              SenderImageWidget(senderId: message.senderId),
              const Gap(8),
            ],
            MessageContentWidget(message: message, isMyMessage: isMyMessage),
          ],
        ),
        MessageAdditionalInfoWidget(message: message, roomId: roomId, isMyMessage: isMyMessage),
      ],
    );
  }
}

/// チャットメッセージの日付
class DateOnChatRoomWidget extends StatelessWidget {
  const DateOnChatRoomWidget({
    super.key,
    this.dateTime,
  });

  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: messageBackgroundColor,
          ),
          child: Text(
            toIsoStringDateWithWeekDay(dateTime),
            style: context.bodySmall,
          ),
        ),
      ),
    );
  }
}

/// ルームページのメッセージ入力欄のウィジェット
class RoomMessageInputWidget extends HookConsumerWidget {
  const RoomMessageInputWidget({
    super.key,
    required this.roomId,
  });

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
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
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
                hintStyle: context.bodySmall,
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
                  ? context.theme.primaryColor
                  : context.theme.disabledColor,
            ),
            child: const Icon(Icons.send, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// メッセージの送り主（相手）の画像を表示するウィジェット。
class SenderImageWidget extends HookConsumerWidget {
  const SenderImageWidget({
    super.key,
    required this.senderId,
  });

  final String senderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(publicUserStreamProvider(senderId)).when(
          data: (publicUser) => CircleImageWidget(diameter: 36, imageURL: publicUser?.imageURL),
          error: (error, stackTrace) => const SizedBox(),
          loading: () => const SizedBox(),
        );
  }
}

/// メッセージの本文を表示するウィジェット。
class MessageContentWidget extends HookConsumerWidget {
  const MessageContentWidget({
    super.key,
    required this.message,
    required this.isMyMessage,
  });

  final Message message;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: BoxConstraints(
        maxWidth:
            (MediaQuery.of(context).size.width - partnerImageSize - horizontalPadding * 3) * 0.9,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
          bottomLeft: Radius.circular(isMyMessage ? 8 : 0),
          bottomRight: Radius.circular(isMyMessage ? 0 : 8),
        ),
        color: isMyMessage ? context.theme.primaryColor : messageBackgroundColor,
      ),
      child: Text(
        message.body,
        style: isMyMessage ? context.bodySmall!.copyWith(color: Colors.white) : context.bodySmall,
      ),
    );
  }
}

/// 送信日時と未既読などを表示するウィジェット。
class MessageAdditionalInfoWidget extends HookConsumerWidget {
  const MessageAdditionalInfoWidget({
    super.key,
    required this.message,
    required this.roomId,
    required this.isMyMessage,
  });

  final Message message;
  final String roomId;
  final bool isMyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        left: isMyMessage ? 0 : partnerImageSize + horizontalPadding,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(to24HourNotationString(message.createdAt.dateTime), style: context.bodySmall),
          if (isMyMessage)
            SizedBox(
              height: 14,
              child: ref.watch(partnerReadStatusStreamProvider(roomId)).when(
                    data: (readStatus) => Text(
                      _isRead(message: message, lastReadAt: readStatus?.lastReadAt.dateTime)
                          ? '既読'
                          : '未読',
                      style: context.bodySmall,
                    ),
                    error: (_, __) => const SizedBox(),
                    loading: () => const SizedBox(),
                  ),
            ),
        ],
      ),
    );
  }

  /// Message.createdAt と 最後に読んだ日を比較して既読かどうかを返す
  bool _isRead({
    required Message message,
    required DateTime? lastReadAt,
  }) {
    final createdAt = message.createdAt.dateTime;
    if (lastReadAt == null || createdAt == null) {
      return false;
    }
    return lastReadAt.isAfter(createdAt);
  }
}
