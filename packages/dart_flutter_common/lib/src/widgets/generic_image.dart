import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// [GenericImage] で表示する画像の形状。
enum ImageShape {
  /// 円形。
  circle,

  /// 正方形。
  square,

  /// 長方形。
  rectangle,
}

/// [CachedNetworkImage] を使用した各種の形状の汎用的な画像ウィジェット。
class GenericImage extends StatelessWidget {
  /// 円形の画像を表示する。
  const GenericImage.circle({
    required this.imageUrl,
    this.onTap,
    this.showDetailOnTap = true,
    this.size,
    this.loadingWidget,
    super.key,
  })  : imageShape = ImageShape.circle,
        borderRadius = null,
        height = null,
        width = null;

  /// 正方形の画像を表示する。
  const GenericImage.square({
    required this.imageUrl,
    this.onTap,
    this.showDetailOnTap = true,
    this.size,
    this.borderRadius,
    this.loadingWidget,
    super.key,
  })  : imageShape = ImageShape.square,
        height = null,
        width = null;

  /// 長方形の画像を表示する。
  const GenericImage.rectangle({
    required this.imageUrl,
    this.onTap,
    this.showDetailOnTap = true,
    required this.height,
    required this.width,
    this.borderRadius,
    this.loadingWidget,
    super.key,
  })  : imageShape = ImageShape.rectangle,
        size = null;

  /// 表示する画像の URL 文字列。
  final String imageUrl;

  /// 表示する画像の形状。
  final ImageShape imageShape;

  /// 画像ウィジェットをタップした際のコールバック関数。
  final VoidCallback? onTap;

  /// 画像ウィジェットをタップした際に画像の詳細画面を表示するかどうか。
  /// [onTap] が指定されているときは、[onTap] が優先される。
  final bool showDetailOnTap;

  /// 円形・正方形で指定する画像のサイズ（直径、一辺の長さ）。
  final double? size;

  /// 長方形で指定する画像の横幅。
  final double? width;

  /// 長方形で指定する画像の高さ。
  final double? height;

  /// 角丸の半径。
  final double? borderRadius;

  /// 読み込み中に表示するウィジェット。
  final Widget? loadingWidget;

  /// 当該画像ウィジェットがインスタンス化された回数。
  /// [Hero] のタグとして使用する。
  /// （環境にもよるが）2^64 回でオーバーフローするが、その上限まで生成される
  /// ことはまずないため許容している。
  static int _instanceCount = 0;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _Image.placeholder(
        imageShape: imageShape,
        size: size,
        height: height,
        width: width,
        borderRadius: borderRadius,
      );
    }
    final tag = _instanceCount.toString();
    _instanceCount++;
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          return onTap!();
        }
        if (showDetailOnTap) {
          return Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => // PhotoView(
                  //   imageProvider: NetworkImage(imageUrl),
                  // ),
                  _ImageDetailView(
                tag: tag,
                imageUrl: imageUrl,
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: tag,
        child: _GenericCachedNetworkImage(
          imageUrl: imageUrl,
          imageShape: imageShape,
          size: size,
          width: width,
          height: height,
          borderRadius: borderRadius,
          loadingWidget: loadingWidget,
        ),
      ),
    );
  }
}

class _GenericCachedNetworkImage extends StatelessWidget {
  const _GenericCachedNetworkImage({
    required this.imageUrl,
    required this.imageShape,
    required this.size,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.loadingWidget,
  });

  /// 表示する画像の URL 文字列。
  final String imageUrl;

  /// 表示する画像の形状。
  final ImageShape imageShape;

  /// 円形・正方形で指定する画像のサイズ（直径、一辺の長さ）。
  final double? size;

  /// 長方形で指定する画像の横幅。
  final double? width;

  /// 長方形で指定する画像の高さ。
  final double? height;

  /// 角丸の半径。
  final double? borderRadius;

  /// 読み込み中に表示するウィジェット。
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return _Image(
          imageShape: imageShape,
          size: size,
          height: height,
          width: width,
          borderRadius: borderRadius,
          decorationImage: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        );
      },
      placeholder: (context, url) =>
          loadingWidget ??
          _Image.placeholder(
            imageShape: imageShape,
            size: size,
            height: height,
            width: width,
            borderRadius: borderRadius,
          ),
      errorWidget: (context, url, error) => _Image.errorWidget(
        imageShape: imageShape,
        size: size,
        height: height,
        width: width,
        borderRadius: borderRadius,
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
    this.decorationImage,
  })  : color = null,
        icon = null;

  const _Image.placeholder({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
  })  : color = Colors.grey,
        decorationImage = null,
        icon = null;

  const _Image.errorWidget({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
  })  : color = Colors.grey,
        decorationImage = null,
        icon = const Icon(
          Icons.broken_image,
          color: Colors.white,
        );

  final ImageShape imageShape;
  final Color? color;
  final double? size;
  final double? height;
  final double? width;
  final double? borderRadius;
  final DecorationImage? decorationImage;
  final Icon? icon;

  static const double _defaultSize = 64;

  @override
  Widget build(BuildContext context) {
    switch (imageShape) {
      case ImageShape.circle:
        return Container(
          height: size ?? _defaultSize,
          width: size ?? _defaultSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            image: decorationImage,
          ),
          child: icon,
        );

      case ImageShape.square:
        return Container(
          height: size ?? _defaultSize,
          width: size ?? _defaultSize,
          decoration: BoxDecoration(
            color: color,
            image: decorationImage,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: icon,
        );

      case ImageShape.rectangle:
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            image: decorationImage,
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          child: icon,
        );
    }
  }
}

/// 画像詳細を全画面で表示する UI.
class _ImageDetailView extends StatelessWidget {
  const _ImageDetailView({
    required this.tag,
    required this.imageUrl,
  });

  final String tag;
  // final Widget child;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: tag),
      ),
    );
  }
}
