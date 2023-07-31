import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// [GenericImage] ウィジェットを使用した汎用的な画像ウィジェットのサンプル。
class GenericImages extends StatelessWidget {
  const GenericImages({super.key});

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
