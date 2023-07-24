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
      body: ListView(
        children: const [
          ListTile(
            leading: GenericImageWidget(
              imageUrl: '',
              imageShape: ImageShape.circle,
            ),
            title: Text('汎用的な画像Widget'),
          ),
        ],
      ),
    );
  }
}
