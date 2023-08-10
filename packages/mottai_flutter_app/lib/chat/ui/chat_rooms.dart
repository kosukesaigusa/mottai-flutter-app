import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../chat_rooms.dart';

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
      appBar: AppBar(
        title: const Text('チャット'),
      ),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          final readChatRooms = ref.watch(chatRoomsStreamProvider(userId));
          return readChatRooms.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => const SizedBox(),
            data: (chatRooms) => ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                // TODO: ListTileにし、デザイン調整する。
                final latestChatMessage = ref.watch(
                  latestMessageProvider(chatRooms[index].chatRoomId),
                );
                final unReadCount =
                    ref.watch(unReadCountProvider(chatRooms[index].chatRoomId));
                if (index == chatRooms.length) {
                  return const Divider(height: 1);
                }
                return SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: 送信者の画像を取得して表示する
                        const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (latestChatMessage != null)
                                  Text(
                                    latestChatMessage.createdAt.dateTime!
                                        .formatRelativeDate(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                // TODO: 送信者名を取得してListTileに表示する
                                const Text(
                                  '送信者',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (latestChatMessage != null)
                                  Text(latestChatMessage.content),
                              ],
                            ),
                          ),
                        ),
                        Text(unReadCount.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
