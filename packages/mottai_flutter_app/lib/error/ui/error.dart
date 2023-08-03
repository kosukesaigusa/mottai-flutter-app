import 'package:flutter/material.dart';

/// 意図しない値が得られたり例外やエラーが発生したりした場合に表示する
/// 代わりに表示するページ。
class UnavailablePage extends StatelessWidget {
  const UnavailablePage(this.object, {super.key});

  final Object? object;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            // TODO: 文言や UI の改善を検討する。
            object == null ? '問題が発生しました。' : object.toString(),
          ),
        ),
      ),
    );
  }
}
