import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/attending_room/attending_room_provider.dart';
import '../../providers/message/message_provider.dart';
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
                child: Text(
                  error.toString(),
                  style: grey12,
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
            const CircleImage(
                size: 48,
                imageURL:
                    'https://firebasestorage.googleapis.com/v0/b/mottai-app-dev-2.appspot.com/o/hosts%2Fyago-san.jpeg?alt=media&token=637a9f78-9243-4ce8-8734-5776a40cc7fd'),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('矢郷 史郎', style: bold12),
                  ref.watch(messagesStreamProvider(attendingRoom.roomId)).when(
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) {
                          print('=============================');
                          print('⛔️ $error');
                          print(stackTrace);
                          print('=============================');
                          return const SizedBox();
                        },
                        data: (messages) => Text(
                          messages.first.body,
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
                Text(
                  humanReadableDateTimeString(attendingRoom.updatedAt),
                  style: grey10,
                ),
                const Gap(4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: attendingRoom.unreadCount > 0
                      ? Center(
                          child: Text(
                            attendingRoom.unreadCount.toString(),
                            style: whiteBold12,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
