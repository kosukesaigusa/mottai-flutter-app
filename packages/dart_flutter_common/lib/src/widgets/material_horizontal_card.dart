import 'package:flutter/material.dart';

import '../../dart_flutter_common.dart';

/// Material 3 のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示するカード
/// ウィジェット。
class MaterialHorizontalCard extends StatelessWidget {
  /// Material 3 のデザインに従って、タイトル、詳細、画像の 3 つを水平方向に表示するカード
  /// ウィジェット。
  const MaterialHorizontalCard({
    required this.title,
    required this.description,
    this.imageUrl,
    super.key,
  });

  /// カードに表示するタイトル。
  final String title;

  /// カードに表示する詳細。
  final String description;

  /// 表示する画像の URL 文字列。
  final String? imageUrl;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
              child: GenericImage.square(imageUrl: imageUrl!, size: 96),
            ),
        ],
      ),
    );
  }
}
