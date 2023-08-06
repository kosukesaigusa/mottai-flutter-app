import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';

/// 開発中の各ページへの導線を表示するページ。
@RoutePage()
class ImageDetailViewStubPage extends StatelessWidget {
  const ImageDetailViewStubPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/imageDetailViewStub';

  /// [ImageDetailViewStubPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画像詳細拡大画面サンプル'),
      ),
      body: const GenericImage.square(
        size: 300,
        imageUrl:
            'https://free-materials.com/adm/wp-content/uploads/2017/02/adtDSC_0905-300x199.jpg',
      ),
    );
  }
}
