import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// [GenericImage] ウィジェットを使用した汎用的な画像ウィジェットのサンプル。
@RoutePage()
class GenericImagesPage extends StatelessWidget {
  const GenericImagesPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/genericImages';

  /// [GenericImagesPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('汎用的な画像ウィジェット'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              const Text('円形'),
              const GenericImage.circle(
                imageUrl: '',
              ),
              const Gap(4),
              const GenericImage.circle(
                imageUrl: 'https://picsum.photos/128',
              ),
              const Gap(4),
              const Text('正方形'),
              const GenericImage.square(
                imageUrl: 'https://picsum.photos/200',
                size: 100,
              ),
              const Gap(4),
              const Text('長方形'),
              GenericImage.rectangle(
                imageUrl: 'https://picsum.photos/100',
                height: 100,
                width: 240,
                borderRadius: 12,
                onTap: () => debugPrint('onTap'),
              ),
              const Gap(4),
              // errorWidgetのサンプル
              GenericImage.rectangle(
                imageUrl: 'https://testinvalidurl.com',
                height: 100,
                width: 240,
                borderRadius: 12,
                onTap: () => debugPrint('onTap'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
