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
        aspectRatio = null,
        maxHeight = null,
        maxWidth = null;

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
        aspectRatio = null,
        maxHeight = null,
        maxWidth = null;

  /// 長方形の画像を表示する。
  const GenericImage.rectangle({
    required this.imageUrl,
    this.onTap,
    this.showDetailOnTap = true,
    this.aspectRatio = 16 / 9,
    this.maxHeight = double.infinity,
    this.maxWidth = double.infinity,
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

  /// 長方形で指定する画像のアスペクト比。
  final double? aspectRatio;

  /// 長方形で指定する画像の最大高さ。
  final double? maxHeight;

  /// 長方形で指定する画像の最大横幅。
  final double? maxWidth;

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
        aspectRatio: aspectRatio,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
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
              builder: (context) => _ImageDetailView(
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
          aspectRatio: aspectRatio,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
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
    required this.aspectRatio,
    required this.maxWidth,
    required this.maxHeight,
    required this.borderRadius,
    required this.loadingWidget,
  });

  /// 表示する画像の URL 文字列。
  final String imageUrl;

  /// 表示する画像の形状。
  final ImageShape imageShape;

  /// 円形・正方形で指定する画像のサイズ（直径、一辺の長さ）。
  final double? size;

  /// 長方形で指定する画像のアスペクト比。
  final double? aspectRatio;

  /// 長方形で指定する画像の高さの最大値。
  final double? maxHeight;

  /// 長方形で指定する画像の横幅の最大値。
  final double? maxWidth;

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
          aspectRatio: aspectRatio,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
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
            aspectRatio: aspectRatio,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            borderRadius: borderRadius,
          ),
      errorWidget: (context, url, error) => _Image.errorWidget(
        imageShape: imageShape,
        size: size,
        aspectRatio: aspectRatio,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        borderRadius: borderRadius,
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.imageShape,
    this.size,
    this.aspectRatio,
    this.maxHeight,
    this.maxWidth,
    this.borderRadius,
    this.decorationImage,
  })  : color = null,
        errorIcon = null;

  const _Image.placeholder({
    required this.imageShape,
    this.size,
    this.aspectRatio,
    this.maxHeight,
    this.maxWidth,
    this.borderRadius,
  })  : color = Colors.grey,
        decorationImage = null,
        errorIcon = null;

  const _Image.errorWidget({
    required this.imageShape,
    this.size,
    this.aspectRatio,
    this.maxHeight,
    this.maxWidth,
    this.borderRadius,
  })  : color = Colors.grey,
        decorationImage = null,
        errorIcon = const Icon(
          Icons.broken_image,
          color: Colors.white,
        );

  final ImageShape imageShape;
  final Color? color;

  /// 円形・正方形で指定する画像のサイズ（直径、一辺の長さ）。
  final double? size;

  /// 円形・正方形で指定する画像のデフォルトサイズ。
  static const double _defaultSize = 64;

  /// 長方形で指定する画像のアスペクト比。
  final double? aspectRatio;

  /// 長方形で指定する画像のアスペクト比のデフォルト値。
  static const double _defaultAspectRatio = 16 / 9;

  /// 長方形で指定する画像の高さ。
  final double? maxHeight;

  /// 長方形で指定する画像の高さのデフォルト値。
  static const double _defaultMaxHeight = double.infinity;

  /// 長方形で指定する画像の横幅の最大値。
  final double? maxWidth;

  /// 長方形で指定する画像の横幅の最大値のデフォルト値。
  static const double _defaultMaxWidth = double.infinity;

  /// 角丸の半径。
  final double? borderRadius;

  /// 表示する画像。
  final DecorationImage? decorationImage;

  /// エラー時に表示するアイコン。
  final Icon? errorIcon;

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
          child: errorIcon,
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
          child: errorIcon,
        );

      case ImageShape.rectangle:
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? _defaultMaxWidth,
            maxHeight: maxHeight ?? _defaultMaxHeight,
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio ?? _defaultAspectRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                image: decorationImage,
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
              ),
              child: errorIcon,
            ),
          ),
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
