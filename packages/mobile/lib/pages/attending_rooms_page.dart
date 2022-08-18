import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../features/auth/auth.dart';
import '../features/message/attending_room.dart';
import '../features/public_user/public_user.dart';
import '../utils/date_time.dart';
import '../utils/extensions/build_context.dart';
import '../widgets/empty_placeholder.dart';
import '../widgets/image.dart';
import '../widgets/loading.dart';
import 'room_page.dart';

/// メッセージタブの参加中のチャットルーム一覧ページ。
class AttendingRoomsPage extends HookConsumerWidget {
  const AttendingRoomsPage({super.key});

  static const path = '/rooms';
  static const name = 'AttendingRoomsPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('メッセージ')),
      body: ref.watch(attendingRoomsProvider).when(
            data: (attendingRooms) => attendingRooms.isEmpty
                ? const EmptyPlaceholderWidget(
                    widget: FaIcon(
                      FontAwesomeIcons.solidComment,
                      size: 48,
                      color: Colors.black45,
                    ),
                    message: 'まだメッセージしている相手がいません。',
                  )
                : ListView.builder(
                    itemBuilder: (context, index) =>
                        AttendingRoomWidget(attendingRoom: attendingRooms[index]),
                    itemCount: attendingRooms.length,
                  ),
            error: (e, __) => EmptyPlaceholderWidget(message: e.toString()),
            loading: () => const PrimarySpinkitCircle(),
          ),
      floatingActionButton: ref.watch(attendingRoomsProvider).when(
            data: (attendingRooms) => attendingRooms.isEmpty
                ? FloatingActionButton(
                    child: const FaIcon(FontAwesomeIcons.solidComment),
                    onPressed: () => ref.read(createChatRoomWithHost1Provider)(),
                  )
                : null,
            error: (_, __) => null,
            loading: () => null,
          ),
    );
  }
}

/// AttendingRoom ページのひとつひとつのウィジェット。
class AttendingRoomWidget extends HookConsumerWidget {
  const AttendingRoomWidget({
    super.key,
    required this.attendingRoom,
  });

  final AttendingRoom attendingRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider).value;
    return userId != null
        ? InkWell(
            onTap: () async {
              // 非同期的に lastReadAt を更新する
              unawaited(
                ref
                    .read(messageRepositoryProvider)
                    .readStatusRef(roomId: attendingRoom.roomId, readStatusId: userId)
                    .set(const ReadStatus(), SetOptions(merge: true)),
              );
              await Navigator.pushNamed<void>(
                context,
                RoomPage.location(roomId: attendingRoom.roomId),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  AttendingRoomPartnerImageWidget(partnerId: attendingRoom.partnerId),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AttendingRoomPartnerNameWidget(partnerId: attendingRoom.partnerId),
                        AttendingRoomLatestMessageWidget(roomId: attendingRoom.roomId),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LatestMessageCreatedAtWidget(roomId: attendingRoom.roomId),
                      const Gap(4),
                      UnreadCountBadgeWidget(roomId: attendingRoom.roomId),
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

/// 参加中のチャットルームの相手の画像を表示するウィジェット。
class AttendingRoomPartnerImageWidget extends HookConsumerWidget {
  const AttendingRoomPartnerImageWidget({
    super.key,
    required this.partnerId,
  });

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(publicUserStreamProvider(partnerId)).when(
          data: (publicUser) => publicUser == null
              ? const CircleImagePlaceholder(diameter: 48)
              : CircleImageWidget(diameter: 48, imageURL: publicUser.imageURL),
          error: (_, __) => const CircleImagePlaceholder(diameter: 48),
          loading: () => const CircleImagePlaceholder(diameter: 48),
        );
  }
}

/// 参加中のチャットルームの相手の名前を表示するウィジェット。
class AttendingRoomPartnerNameWidget extends HookConsumerWidget {
  const AttendingRoomPartnerNameWidget({
    super.key,
    required this.partnerId,
  });

  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(publicUserStreamProvider(partnerId)).when(
          data: (publicUser) => publicUser == null
              ? Text('-', style: context.titleSmall)
              : Text(publicUser.displayName, style: context.titleSmall),
          error: (error, stackTrace) => const SizedBox(),
          loading: () => const SizedBox(),
        );
  }
}

/// 参加中のチャットルームの直近のメッセージを表示するウィジェット。
class AttendingRoomLatestMessageWidget extends HookConsumerWidget {
  const AttendingRoomLatestMessageWidget({
    super.key,
    required this.roomId,
  });

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(latestMessageOfRoomProvider(roomId));
    return Text(
      message == null ? 'ルームが作成されました。' : message.body,
      style: context.bodySmall,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}

/// 直近のメッセージの日時を表示するウィジェット。
class LatestMessageCreatedAtWidget extends HookConsumerWidget {
  const LatestMessageCreatedAtWidget({
    super.key,
    required this.roomId,
  });

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(latestMessageOfRoomProvider(roomId));
    if (message == null) {
      return const SizedBox();
    }
    return Text(
      humanReadableDateTimeString(message.createdAt.dateTime),
      style: context.bodySmall,
    );
  }
}

/// 未読数カウントのバッジウィジェット。
class UnreadCountBadgeWidget extends HookConsumerWidget {
  const UnreadCountBadgeWidget({
    super.key,
    required this.roomId,
  });

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(unreadCountProvider(roomId)).when(
          data: (count) => count > 0
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : count.toString(),
                      style: context.titleSmall!.copyWith(color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox(width: 20, height: 20),
          error: (_, __) => const SizedBox(width: 20, height: 20),
          loading: () => const SizedBox(width: 20, height: 20),
        );
  }
}
