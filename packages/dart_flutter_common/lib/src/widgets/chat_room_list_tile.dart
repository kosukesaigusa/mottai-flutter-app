import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// 汎用的な `ChatRoomListTile`を作るウィジェット。
class ChatRoomListTile extends StatelessWidget {
  /// 汎用的な `ChatRoomListTile`を作るウィジェット。
  const ChatRoomListTile({
    super.key,
    required this.onTap,
    required this.chatPartnerImageUrl,
    required this.latestChatMessageCreatedAt,
    required this.latestChatMessageContent,
    required this.chatPartnerDisplayName,
    required this.unReadCountString,
    this.decoration,
    this.height,
    this.width,
  });

  /// ListTile をタップした際のコールバック関数
  final VoidCallback? onTap;

  /// メッセージ送信者の画像の URL 文字列
  final String chatPartnerImageUrl;

  /// 最新メッセージの日付
  final DateTime? latestChatMessageCreatedAt;

  /// 最新メッセージの内容
  final String? latestChatMessageContent;

  /// メッセージ送信者の名前
  final String chatPartnerDisplayName;

  /// 未読メッセージ数
  final String unReadCountString;

  /// ListTile の幅
  final double? width;

  /// ListTile の高さ
  final double? height;

  /// ListTile に枠線をつけるなどの装飾
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: decoration,
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
                radius: 28,
                child: Icon(Icons.person),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (latestChatMessageCreatedAt != null)
                      Text(
                        latestChatMessageCreatedAt!.formatRelativeDate(),
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      chatPartnerDisplayName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (latestChatMessageContent != null)
                      Text(
                        latestChatMessageContent!,
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
    );
  }
}
