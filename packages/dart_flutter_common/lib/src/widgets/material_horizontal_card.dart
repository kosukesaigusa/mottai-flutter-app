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
    required this.imageUrl,
    super.key,
  });

  /// 表示する画像の URL 文字列。
  final String imageUrl;

  /// カードに表示するタイトル。
  final String title;

  /// カードに表示する詳細。
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: GenericImage.square(
              imageUrl: imageUrl,
            ),
          ),
        ],
      ),
    );
  }
}
