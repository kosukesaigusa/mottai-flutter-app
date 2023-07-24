import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';

class DevelopmentComponents extends StatelessWidget {
  const DevelopmentComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開発中のComponents'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              const Text('汎用的な画像Widget'),
              const GenericImageWidget(
                imageUrl: 'https://picsum.photos/128',
                imageShape: ImageShape.circle,
              ),
              const SizedBox(
                height: 10,
              ),
              const GenericImageWidget(
                imageUrl: 'https://picsum.photos/200',
                imageShape: ImageShape.square,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              GenericImageWidget(
                imageUrl: 'https://picsum.photos/100',
                imageShape: ImageShape.rectangle,
                height: 100,
                radius: 10,
                onTap: () => debugPrint('onTap'),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
