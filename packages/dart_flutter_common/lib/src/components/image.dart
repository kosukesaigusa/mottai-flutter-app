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
  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? _ImageDisplayContainer.placeholder(
            imageShape: imageShape,
            size: size,
            height: height,
            width: width,
            radius: borderRadius,
          )
        : GestureDetector(
            onTap: onTap,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) {
                return _ImageDisplayContainer(
                  imageShape: imageShape,
                  size: size,
                  height: height,
                  width: width,
                  radius: borderRadius,
                  decorationImage: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                );
              },
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
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
    this.radius,
    this.decorationImage,
  }) : color = null;

  const _ImageDisplayContainer.placeholder({
    required this.imageShape,
    this.size,
    this.height,
    this.width,
    this.radius,
  })  : color = Colors.grey,
        decorationImage = null;

  final ImageShape imageShape;
  final Color? color;
  final double? size;
  final double? height;
  final double? width;
  final double? radius;
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
            ),
          );
        }
    }
  }
}
