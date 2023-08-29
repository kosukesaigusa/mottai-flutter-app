import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../user/user_mode.dart';
import '../chat_room.dart';
import '../chat_rooms.dart';
import 'chat_room.dart';

@RoutePage()
class ChatRoomsPage extends ConsumerWidget {
  const ChatRoomsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'chatRooms';

  /// [ChatRoomsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMode = ref.watch(userModeStateProvider);
    return Scaffold(
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          final readChatRooms = ref.watch(chatRoomsStreamProvider(userId));
          return readChatRooms.when(
            data: (chatRooms) {
              if (chatRooms.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(36),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat,
                          size: 80,
                          color: Colors.black12,
                        ),
                        const Gap(16),
                        if (userMode == UserMode.worker)
                          const Text(
                            '表示するチャットルームがありません。'
                            '「探す」から興味のあるお手伝いを募集しているホストを探して、'
                            'メッセージを送ってみましょう。',
                          )
                        else
                          const Text(
                            '表示するチャットルームがありません。あなたの募集するお手伝いに'
                            '興味を持ったワーカーからメッセージが届きます。',
                          ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  final latestChatMessage =
                      ref.watch(latestMessageProvider(chatRoom.chatRoomId));
                  return GenericChatRoom(
                    imageUrl: ref.watch(chatPartnerImageUrlProvider(chatRoom)),
                    title: ref.watch(chatPartnerDisplayNameProvider(chatRoom)),
                    latestMessage: latestChatMessage?.content,
                    onTap: () => context.router.pushNamed(
                      ChatRoomPage.location(chatRoomId: chatRoom.chatRoomId),
                    ),
                    updatedAt: latestChatMessage?.createdAt,
                    unReadCountString:
                        ref.watch(unReadCountStringProvider(chatRoom)),
                  );
                },
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          );
        },
      ),
    );
  }
}
