import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
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
                  final readChatRoom = chatRooms[index];
                  // Records でchatRoomで扱いたいデータをまとめた
                  final chatRoom = (
                    id: readChatRoom.chatRoomId,
                    chatPartnerImageUrl: ref.watch(
                      chatPartnerImageUrlProvider(readChatRoom),
                    ),
                    chatPartnerDisplayName: ref.watch(
                      chatPartnerDisplayNameProvider(
                        readChatRoom,
                      ),
                    ),
                    latestChatMessage: ref.watch(
                      latestMessageProvider(readChatRoom.chatRoomId),
                    ),
                    unReadCountString: ref.watch(
                      unReadCountStringProvider(readChatRoom),
                    )
                  );
                  return _ChatRoomListItem(
                    chatRoomId: chatRoom.id,
                    chatPartnerImageUrl: chatRoom.chatPartnerImageUrl,
                    latestChatMessage: chatRoom.latestChatMessage,
                    chatPartnerDisplayName: chatRoom.chatPartnerDisplayName,
                    unReadCountString: chatRoom.unReadCountString,
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

/// `ChatRoomListTile` を使ってmottaiアプリ用に作った ListItem
class _ChatRoomListItem extends StatelessWidget {
  const _ChatRoomListItem({
    required this.chatRoomId,
    required this.chatPartnerImageUrl,
    required this.latestChatMessage,
    required this.chatPartnerDisplayName,
    required this.unReadCountString,
  });

  /// chatRoomId
  final String chatRoomId;

  /// チャット相手の画像
  final String chatPartnerImageUrl;

  /// 未読メッセージのドキュメント
  final ReadChatMessage? latestChatMessage;

  /// チャット相手の名前
  final String chatPartnerDisplayName;

  /// 未読メッセージ数
  final String unReadCountString;

  @override
  Widget build(BuildContext context) {
    return ChatRoomListTile(
      onTap: () => context.router.pushNamed(
        ChatRoomPage.location(
          chatRoomId: chatRoomId,
        ),
      ),
      chatPartnerImageUrl: chatPartnerImageUrl,
      latestChatMessageCreatedAt: latestChatMessage?.createdAt,
      latestChatMessageContent: latestChatMessage?.content,
      chatPartnerDisplayName: chatPartnerDisplayName,
      unReadCountString: unReadCountString,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
