import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// Material 3 の Figma のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示する
/// カードウィジェット。
class MaterialHorizontalCard extends StatelessWidget {
  /// Material 3 の Figma のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示する
  /// カードウィジェット。
  const MaterialHorizontalCard({
    this.headerImageUrl,
    required this.header,
    required this.subhead,
    this.mediaImageUrl,
    super.key,
  });

  /// ヘッダー画像の URL 文字列。
  final String? headerImageUrl;

  /// ヘッダー文字列。
  final String header;

  /// ヘッダー下に表示する文字列。
  final String subhead;

  /// メディア画像の URL 文字列。
  final String? mediaImageUrl;

  /// カードの角丸の半径。
  static const double _borderRadius = 8;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (headerImageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GenericImage.circle(
                        imageUrl: headerImageUrl!,
                        size: 40,
                      ),
                    ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          header,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subhead,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (mediaImageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
              child: GenericImage.square(
                imageUrl: mediaImageUrl!,
                size: 80,
              ),
            ),
        ],
      ),
    );
  }
}
