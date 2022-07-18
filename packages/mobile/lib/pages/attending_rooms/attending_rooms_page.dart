import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/attending_room/attending_room.dart';
import '../../providers/auth/auth.dart';
import '../../providers/message/message.dart';
import '../../providers/public_user/public_user_providers.dart';
import '../../services/scaffold_messenger_service.dart';
import '../../utils/date_time.dart';
import '../../utils/extensions/build_context.dart';
import '../../utils/utils.dart';
import '../../widgets/common/image.dart';
import '../../widgets/loading/loading.dart';
import '../room/room_page.dart';

/// メッセージタブの参加中のチャットルーム一覧ページ。
class AttendingRoomsPage extends StatefulHookConsumerWidget {
  const AttendingRoomsPage({super.key});

  static const path = '/rooms';
  static const name = 'AttendingRoomsPage';
  static const location = path;

  @override
  ConsumerState<AttendingRoomsPage> createState() => _AttendingRoomsPageState();
}

class _AttendingRoomsPageState extends ConsumerState<AttendingRoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メッセージ')),
      body: ref.watch(attendingRoomsStreamProvider).when<Widget>(
            data: (attendingRooms) => attendingRooms.isEmpty
                ? Center(
                    child: Text(
                      'まだメッセージしている相手がいません。',
                      style: context.bodySmall,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) =>
                        AttendingRoomWidget(attendingRoom: attendingRooms[index]),
                    itemCount: attendingRooms.length,
                  ),
            error: (errorObject, __) => Center(
              child: SizedBox(
                width: 280,
                child: Text(
                  errorObject.toString(),
                  style: context.bodySmall,
                ),
              ),
            ),
            loading: () => const PrimarySpinkitCircle(),
          ),
      floatingActionButton: _showFloatingActionButton ? _fab : null,
    );
  }

  // TODO: 開発中のみ。後で消す。
  bool get _showFloatingActionButton {
    try {
      return (ref.watch(attendingRoomsStreamProvider).value ?? <AttendingRoom>[]).isEmpty;
    } on SignInRequiredException {
      return false;
    } on Exception {
      return false;
    }
  }

  // TODO: 開発中のみ。後で消す。
  Widget get _fab => FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.solidComment),
        onPressed: () async {
          final userId = ref.watch(userIdProvider).value;
          if (userId == null) {
            return;
          }
          final roomId = uuid;
          const hostId = String.fromEnvironment('HOST_1_ID');
          await ref
              .read(messageRepositoryProvider)
              .roomRef(roomId: roomId)
              .set(Room(roomId: roomId, hostId: hostId, workerId: userId));
          await ref
              .read(messageRepositoryProvider)
              .attendingRoomRef(userId: userId, roomId: roomId)
              .set(
                AttendingRoom(
                  roomId: roomId,
                  partnerId: hostId,
                ),
              );
          ref.read(scaffoldMessengerServiceProvider).showSnackBar('【テスト用】ホスト 1 とのルームを作成しました。');
        },
      );
}

/// AttendingRoom ページのひとつひとつのウィジェット
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
    return ref.watch(publicUserStreamProvider(partnerId)).when<Widget>(
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
    return ref.watch(messagesStreamProvider(roomId)).when(
          data: (messages) => Text(
            messages.isEmpty ? 'ルームが作成されました。' : messages.first.body,
            style: context.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          error: (_, __) => const SizedBox(),
          loading: () => const SizedBox(),
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
    return ref.watch(messagesStreamProvider(roomId)).when(
          data: (messages) => Text(
            messages.isEmpty ? '' : humanReadableDateTimeString(messages.first.createdAt),
            style: context.bodySmall,
          ),
          error: (_, __) => const SizedBox(),
          loading: () => const SizedBox(),
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
    return ref.watch(unreadCountStreamProvider(roomId)).when(
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
