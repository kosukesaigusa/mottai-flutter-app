import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// プライマリカラーの SpinkitCircle を表示する
class PrimarySpinkitCircle extends StatelessWidget {
  const PrimarySpinkitCircle({this.size = 48});

  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

/// 二度押しを防止したいときなどの重ねるローディングウィジェット
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({this.backgroundColor = Colors.black26});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(child: PrimarySpinkitCircle(size: 48)),
      ),
    );
  }
}
