import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageShape {
  circle,
  square,
  rectangle,
}

class GenericImageWidget extends StatelessWidget {
  const GenericImageWidget.circle({
    required this.imageUrl,
    this.onTap,
    this.size,
    this.loading,
    super.key,
  })  : imageShape = ImageShape.circle,
        borderRadius = null,
        height = null,
        width = null;

  const GenericImageWidget.square({
    required this.imageUrl,
    this.onTap,
    this.size,
    this.borderRadius,
    this.loading,
    super.key,
  })  : imageShape = ImageShape.square,
        height = null,
        width = null;

  const GenericImageWidget.reqtangle({
    required this.imageUrl,
    this.onTap,
    required this.height,
    required this.width,
    this.borderRadius,
    this.loading,
    super.key,
  })  : imageShape = ImageShape.rectangle,
        size = null;

  final String imageUrl;
  final ImageShape imageShape;
  final VoidCallback? onTap;
  final double? size;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Widget? loading;
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _ImageDisplayContainer.placeholder(
        imageShape: imageShape,
        size: size,
        height: height,
        width: width,
        borderRadius: borderRadius,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) {
          return _ImageDisplayContainer(
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
            loading ??
            _ImageDisplayContainer.placeholder(
              imageShape: imageShape,
              size: size,
              height: height,
              width: width,
              borderRadius: borderRadius,
            ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image),
        ),
      ),
    );
  }
}

class _ImageDisplayContainer extends StatelessWidget {
  const _ImageDisplayContainer({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
    this.decorationImage,
  }) : color = null;

  const _ImageDisplayContainer.placeholder({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.borderRadius,
  })  : color = Colors.grey,
        decorationImage = null;

  final ImageShape imageShape;
  final Color? color;
  final double? size;
  final double? height;
  final double? width;
  final double? borderRadius;
  final DecorationImage? decorationImage;

  static const double _defaultSize = 64;

  @override
  Widget build(BuildContext context) {
    switch (imageShape) {
      case ImageShape.circle:
        {
          return Container(
            height: size ?? _defaultSize,
            width: size ?? _defaultSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              image: decorationImage,
            ),
          );
        }

      case ImageShape.square:
        {
          return Container(
            height: size ?? _defaultSize,
            width: size ?? _defaultSize,
            decoration: BoxDecoration(
              color: color,
              image: decorationImage,
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
          );
        }

      case ImageShape.rectangle:
        {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              image: decorationImage,
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
          );
        }
    }
  }
}
