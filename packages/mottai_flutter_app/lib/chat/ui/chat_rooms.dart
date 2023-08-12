import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../chat_room.dart';
import '../chat_rooms.dart';
import 'chat_room.dart';

@RoutePage()
class ChatRoomsPage extends ConsumerWidget {
  const ChatRoomsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/chatRooms';

  /// [ChatRoomsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('チャット')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          final readChatRooms = ref.watch(chatRoomsStreamProvider(userId));
          return readChatRooms.when(
            data: (chatRooms) => ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final readChatRoom = chatRooms[index];
                // TODO: ListTileにし、デザイン調整する。
                final chatPartnerImageUrl =
                    ref.watch(chatPartnerImageUrlProvider(readChatRoom));
                final chatPartnerDisplayName = ref.watch(
                  chatPartnerDisplayNameProvider(
                    readChatRoom,
                  ),
                );
                final latestChatMessage = ref.watch(
                  latestMessageProvider(readChatRoom.chatRoomId),
                );
                final unReadCountString =
                    ref.watch(unReadCountStringProvider(readChatRoom));
                return InkWell(
                  onTap: () => context.router.pushNamed(
                    ChatRoomPage.location(
                      chatRoomId: readChatRoom.chatRoomId,
                    ),
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chatPartnerImageUrl.isNotEmpty)
                            GenericImage.circle(
                              imageUrl: chatPartnerImageUrl,
                              size: 64,
                            )
                          else
                            const CircleAvatar(
                              radius: 32,
                              child: Icon(Icons.person),
                            ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (latestChatMessage?.createdAt != null)
                                    Text(
                                      latestChatMessage!.createdAt!
                                          .formatRelativeDate(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  Text(
                                    chatPartnerDisplayName,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (latestChatMessage != null)
                                    Text(
                                      latestChatMessage.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (unReadCountString.isNotEmpty)
                            Badge(label: Text(unReadCountString)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          );
        },
      ),
    );
  }
}
