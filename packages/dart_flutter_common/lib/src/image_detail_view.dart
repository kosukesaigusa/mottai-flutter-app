import 'package:flutter/material.dart';

class DetailDisplayableImage extends StatelessWidget {
  const DetailDisplayableImage({
    required this.image,
    super.key,
  });

  final Image image;

  /// インスタンス生成された回数。
  /// Heroのタグとして使用。環境にもよるが2^64回でオーバーフロー
  /// そこまでの数生成されることはないため、この方法としている。
  static int _instanceCount = 0;

  @override
  Widget build(BuildContext context) {
    final tag = _instanceCount.toString();
    _instanceCount++;
    return GestureDetector(
      onTap: () => Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => _ImageDetailView(
            tag: tag,
            image: image,
          ),
        ),
      ),
      child: Hero(
        tag: tag,
        child: image,
      ),
    );
  }
}

// 詳細画像表示
class _ImageDetailView extends StatelessWidget {
  const _ImageDetailView({
    required this.tag,
    required this.image,
  });

  final String tag;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景、タッチイベント捕捉Widget
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
        ),
        // 画像表示Widget
        Center(
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: Hero(
              tag: tag,
              child: image,
            ),
          ),
        ),
      ],
    );
  }
}
