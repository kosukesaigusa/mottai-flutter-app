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
              const GenericImageWidget.circle(
                imageUrl: '',
              ),
              const SizedBox(
                height: 10,
              ),
              const GenericImageWidget.circle(
                imageUrl: 'https://picsum.photos/128',
              ),
              const SizedBox(
                height: 10,
              ),
              const GenericImageWidget.square(
                imageUrl: 'https://picsum.photos/200',
                size: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              GenericImageWidget.reqtangle(
                imageUrl: 'https://picsum.photos/100',
                height: 100,
                width: 250,
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
