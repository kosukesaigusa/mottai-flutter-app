import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/attending_room/attending_room_provider.dart';
import '../../providers/message/message_provider.dart';
import '../../providers/public_user/public_user.dart';
import '../../route/utils.dart';
import '../../theme/theme.dart';
import '../../widgets/common/loading.dart';
import '../room/room_page.dart';

class AttendingRoomsPage extends StatefulHookConsumerWidget {
  const AttendingRoomsPage({Key? key}) : super(key: key);

  static const path = '/attending-rooms/';
  static const name = 'AttendingRoomsPage';

  @override
  ConsumerState<AttendingRoomsPage> createState() => _AttendingRoomsPageState();
}

class _AttendingRoomsPageState extends ConsumerState<AttendingRoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(attendingRoomsStreamProvider).when<Widget>(
            loading: () => const PrimarySpinkitCircle(),
            error: (error, stackTrace) {
              print('=============================');
              print('⛔️ $error');
              print(stackTrace);
              print('=============================');
              return Center(
                child: SizedBox(
                  width: 280,
                  child: Text(
                    error.toString(),
                    style: grey12,
                  ),
                ),
              );
            },
            data: (attendingRooms) => attendingRooms.isEmpty
                ? Center(
                    child: Text(
                      'まだメッセージしている相手がいません。',
                      style: grey12,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => AttendingRoomWidget(attendingRooms[index]),
                    itemCount: attendingRooms.length,
                  ),
          ),
    );
  }
}

/// AttendingRoom ページのひとつひとつのウィジェット
class AttendingRoomWidget extends HookConsumerWidget {
  const AttendingRoomWidget(this.attendingRoom);
  final AttendingRoom attendingRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          RoomPage.path,
          arguments: RouteArguments(<String, dynamic>{'roomId': attendingRoom.roomId}),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ref.watch(publicUserStreamProvider(attendingRoom.partnerId)).when<Widget>(
                  loading: () => const CirclePlaceHolder(size: 48),
                  error: (error, stackTrace) => const CirclePlaceHolder(size: 48),
                  data: (publicUser) => publicUser == null
                      ? const CirclePlaceHolder(size: 48)
                      : CircleImage(size: 48, imageURL: publicUser.imageURL),
                ),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ref.watch(publicUserStreamProvider(attendingRoom.partnerId)).when<Widget>(
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) => const SizedBox(),
                        data: (publicUser) => publicUser == null
                            ? const Text('-', style: bold12)
                            : Text(publicUser.displayName, style: bold12),
                      ),
                  ref.watch(messagesStreamProvider(attendingRoom.roomId)).when<Widget>(
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) {
                          print('=============================');
                          print('⛔️ $error');
                          print(stackTrace);
                          print('=============================');
                          return const SizedBox();
                        },
                        data: (messages) => Text(
                          messages.isEmpty ? 'ルームが作成されました。' : messages.first.body,
                          style: grey12,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                ],
              ),
            ),
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ref.watch(messagesStreamProvider(attendingRoom.roomId)).when<Widget>(
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                      data: (messages) => Text(
                        messages.isEmpty
                            ? ''
                            : humanReadableDateTimeString(messages.first.createdAt),
                        style: grey10,
                      ),
                    ),
                const Gap(4),
                attendingRoom.unreadCount > 0
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: Text(
                            attendingRoom.unreadCount.toString(),
                            style: whiteBold12,
                          ),
                        ),
                      )
                    : const SizedBox(width: 20, height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
