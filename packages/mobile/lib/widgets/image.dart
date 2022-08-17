import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'shimmer.dart';

/// CachedNetworkImage で指定した大きさの正方形の画像を表示するウィジェット。
/// 大きさを指定しなかった場合は AspectRatio により横幅いっぱい、アスペクト比 1:1 の画像となる。
/// imageURL が null または空文字の場合はプレースホルダを表示する。
class SquareImageWidget extends StatelessWidget {
  const SquareImageWidget({
    super.key,
    required this.imageURL,
    this.size,
    this.placeholderSize,
    this.placeholder,
    this.errorWidget,
  });

  final String? imageURL;
  final double? size;
  final double? placeholderSize;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    // ローカルマシンの Django サーバサイドに接続している時などは、
    // 画像の URL としてふさわしくない文字列が含まれることが多々あり、その度に例外が発生して
    // 効率が悪いため、常にプレースホルダ画像を表示するようにも設定できるようにしている
    if (const bool.fromEnvironment('ALWAYS_SHOW_PLACEHOLDER_IMAGE')) {
      return SquareImagePlaceholder(size: placeholderSize ?? size);
    }
    if ((imageURL ?? '').isEmpty) {
      return SquareImagePlaceholder(size: placeholderSize ?? size);
    }
    return CachedNetworkImage(
      imageUrl: imageURL!,
      imageBuilder: (context, imageProvider) => SizedBox(
        width: size,
        height: size,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) =>
          placeholder ?? SquareShimmerImagePlaceholder(size: placeholderSize ?? size),
      errorWidget: (context, url, dynamic error) =>
          errorWidget ?? SquareImagePlaceholder(size: placeholderSize ?? size),
    );
  }
}

/// CachedNetworkImage で正方形の画像を表示する際のプレースホルダ。
class SquareImagePlaceholder extends StatelessWidget {
  const SquareImagePlaceholder({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const AspectRatio(
        aspectRatio: 1,
        // AspectRatio でいっぱいに広がる
        child: ColoredBox(color: Colors.black12),
      ),
    );
  }
}

/// CachedNetworkImage で正方形の画像を表示する際の Shimmer のプレースホルダ。
class SquareShimmerImagePlaceholder extends StatelessWidget {
  const SquareShimmerImagePlaceholder({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const AspectRatio(
        aspectRatio: 1,
        // AspectRatio でいっぱいに広がる
        child: ShimmerWidget.rectangular(width: double.infinity, height: double.infinity),
      ),
    );
  }
}

/// CachedNetworkImage で丸画像を表示するウィジェット。
/// imageURL が null または空文字の場合はプレースホルダを表示する。
class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({
    super.key,
    required this.imageURL,
    required this.diameter,
    this.placeholder,
    this.errorWidget,
  });

  final String? imageURL;
  final double diameter;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    // ローカルマシンの Django サーバサイドに接続している時などは、
    // 画像の URL としてふさわしくない文字列が含まれることが多々あり、その度に例外が発生して
    // 効率が悪いため、常にプレースホルダ画像を表示するようにも設定できるようにしている
    if (const bool.fromEnvironment('ALWAYS_SHOW_PLACEHOLDER_IMAGE')) {
      return CircleImagePlaceholder(diameter: diameter);
    }
    if ((imageURL ?? '').isEmpty) {
      return CircleImagePlaceholder(diameter: diameter);
    }
    return CachedNetworkImage(
      imageUrl: imageURL!,
      imageBuilder: (context, imageProvider) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(fit: BoxFit.fill, image: imageProvider),
        ),
      ),
      placeholder: (context, url) =>
          placeholder ?? CircleShimmerImagePlaceholder(diameter: diameter),
      errorWidget: (context, url, dynamic error) =>
          errorWidget ?? CircleImagePlaceholder(diameter: diameter),
    );
  }
}

/// CachedNetworkImage で丸画像を表示する際のプレースホルダ。
class CircleImagePlaceholder extends StatelessWidget {
  const CircleImagePlaceholder({
    super.key,
    required this.diameter,
    this.placeholderColor = Colors.white,
  });

  final double diameter;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}

/// CachedNetworkImage で丸画像を表示する際の Shimmer のプレースホルダ。
class CircleShimmerImagePlaceholder extends StatelessWidget {
  const CircleShimmerImagePlaceholder({
    super.key,
    required this.diameter,
  });

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.circular(width: diameter, height: diameter);
  }
}
