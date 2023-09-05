import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// Material 3 のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示するカード
/// ウィジェット。
class MaterialHorizontalCard extends StatelessWidget {
  /// Material 3 のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示するカード
  /// ウィジェット。
  const MaterialHorizontalCard({
    this.headerImageUrl,
    required this.header,
    required this.subhead,
    this.subheadMaxLines = 1,
    this.mediaImageUrl,
    this.borderRadius = 8,
    this.contentVerticalPadding = 16,
    this.contentHorizontalPadding = 16,
    this.headerImageRightPadding = 16,
    this.headerImageSize = 40,
    this.mediaImageSize = 80,
    super.key,
  });

  /// ヘッダー画像の URL 文字列。
  final String? headerImageUrl;

  /// ヘッダー文字列。
  final String header;

  /// ヘッダー下に表示する文字列。
  final String subhead;

  /// ヘッダー下に表示する文字列の最大行数。
  final int subheadMaxLines;

  /// メディア画像の URL 文字列。
  final String? mediaImageUrl;

  /// カードの角丸の半径。
  final double borderRadius;

  /// ヘッダー画像の右側の余白。
  final double headerImageRightPadding;

  /// コンテンツ部分（左側）の垂直方向の余白。
  final double contentVerticalPadding;

  /// コンテンツ部分（左側）の水平方向の余白。
  final double contentHorizontalPadding;

  /// ヘッダー画像のサイズ。
  final double headerImageSize;

  /// メディア画像のサイズ。
  final double mediaImageSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: contentVerticalPadding,
                horizontal: contentHorizontalPadding,
              ),
              child: Row(
                children: [
                  if (headerImageUrl != null)
                    Padding(
                      padding: EdgeInsets.only(right: headerImageRightPadding),
                      child: GenericImage.circle(
                        imageUrl: headerImageUrl!,
                        size: headerImageSize,
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
                          style: Theme.of(context).textTheme.labelSmall,
                          maxLines: subheadMaxLines,
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
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: GenericImage.square(
                imageUrl: mediaImageUrl!,
                size: mediaImageSize,
              ),
            ),
        ],
      ),
    );
  }
}
