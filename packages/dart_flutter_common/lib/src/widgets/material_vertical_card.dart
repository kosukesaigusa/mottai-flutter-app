import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// Material 3 の Figma のデザインに従って、垂直方向に各要素を表示するカードウィジェット。
class MaterialVerticalCard extends StatelessWidget {
  /// Material 3 の Figma のデザインに従って、垂直方向に各要素を表示するカードウィジェット。
  const MaterialVerticalCard({
    required this.headerImageUrl,
    required this.header,
    this.subhead,
    this.menuButtonOnPressed,
    this.imageUrl,
    required this.title,
    required this.content,
    this.actions,
    super.key,
  });

  /// カードのヘッダーに表示する画像の URL 文字列。
  final String headerImageUrl;

  /// カードのヘッダーに表示するタイトル。
  final String header;

  /// カードのヘッダーに表示するサブタイトル。
  final String? subhead;

  /// カードのヘッダーに表示するメニューボタンのコールバック。
  final VoidCallback? menuButtonOnPressed;

  /// カードに表示する画像の URL 文字列。
  final String? imageUrl;

  /// カードに表示するタイトル。
  final String title;

  /// カードに表示するコンテンツ。
  final String content;

  /// カードに表示するアクションボタンのリスト。
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      GenericImage.circle(imageUrl: headerImageUrl, size: 40),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              header,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subhead != null)
                              Text(
                                subhead!,
                                style: Theme.of(context).textTheme.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (menuButtonOnPressed != null)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: menuButtonOnPressed,
                  ),
              ],
            ),
          ),
          if (imageUrl != null) GenericImage.rectangle(imageUrl: imageUrl!),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                Text(content),
                const SizedBox(height: 32),
                if ((actions ?? []).isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
