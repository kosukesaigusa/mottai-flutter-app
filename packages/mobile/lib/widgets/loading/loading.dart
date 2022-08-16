import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/extensions/build_context.dart';

/// プライマリカラーの SpinkitCircle を表示する
class PrimarySpinkitCircle extends StatelessWidget {
  const PrimarySpinkitCircle({super.key, this.size = 48});

  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size,
      color: context.theme.primaryColor,
    );
  }
}

/// 二度押しを防止したいときなどの重ねるローディングウィジェット
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({
    super.key,
    this.backgroundColor = Colors.black26,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: const SizedBox.expand(
        child: Center(child: PrimarySpinkitCircle()),
      ),
    );
  }
}
