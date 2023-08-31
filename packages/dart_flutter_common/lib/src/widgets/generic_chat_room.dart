import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// チャットルーム一覧画面で用いる、汎用的な各チャットルームの UI.
class GenericChatRoom extends StatelessWidget {
  /// チャットルーム一覧画面で用いる、汎用的な各チャットルームの UI を作成する。
  const GenericChatRoom({
    super.key,
    required this.imageUrl,
    required this.title,
    this.latestMessage,
    this.onTap,
    this.updatedAt,
    this.unReadCountString,
    this.imageSize = 64,
  });

  /// チャットルームの画像の URL 文字列。
  final String? imageUrl;

  /// チャットルームのタイトル。
  final String title;

  /// 最新メッセージ文字列。
  final String? latestMessage;

  /// 各チャットルームをタップした際のコールバック関数。
  final VoidCallback? onTap;

  /// 更新日時や最新メッセージの時刻。
  final DateTime? updatedAt;

  /// [Badge] で表示する未読メッセージ数の文字列。単なる数字だけではなく、たとえば +99 のよう
  /// な表記ができるように文字列型としている。
  final String? unReadCountString;

  /// チャットルームの画像のサイズ。
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((imageUrl ?? '').isNotEmpty)
              GenericImage.circle(imageUrl: imageUrl!, size: imageSize)
            else
              CircleAvatar(
                radius: imageSize / 2,
                child: const Icon(Icons.person),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (updatedAt != null)
                      Text(
                        updatedAt!.formatRelativeDate(),
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (latestMessage != null)
                      Text(
                        latestMessage!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
            if ((unReadCountString ?? '').isNotEmpty)
              Badge(label: Text(unReadCountString!)),
          ],
        ),
      ),
    );
  }
}
