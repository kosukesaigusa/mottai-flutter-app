import 'package:flutter/material.dart';

import './image_detail_view.dart';

/// 開発中の各ページへの導線を表示するページ。
class ImageDetailViewStubPage extends StatelessWidget {
  const ImageDetailViewStubPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画像詳細拡大画面サンプル'),
      ),
      body: DetailDisplayableImage(
        image: Image.network(
          'https://free-materials.com/adm/wp-content/uploads/2017/02/adtDSC_0905-300x199.jpg',
        ),
      ),
    );
  }
}
