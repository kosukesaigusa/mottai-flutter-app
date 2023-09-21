import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アプリ全体に重ねるローディング UI を表示するかどうか。
final overlayLoadingStateProvider = StateProvider<bool>((_) => false);

/// 二度押しを防止したいときなどにアプリ全体に重ねるローディング UI.
class OverlayLoading extends StatelessWidget {
  const OverlayLoading({
    super.key,
    this.backgroundColor = Colors.black26,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: const SizedBox.expand(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
