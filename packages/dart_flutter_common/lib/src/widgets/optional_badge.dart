import 'package:flutter/material.dart';

/// 入力が必須か任意かを表すバッジ
/// [isRequired] の値によって、必須か任意の文字を選択して返す。
class OptionalBadge extends StatelessWidget {
  /// 入力が必須か任意かを表すバッジ
  const OptionalBadge({
    super.key,
    this.isRequired = false,
  });

  /// 必須か否か
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (isRequired) {
      return const Badge(
        label: Text('必須'),
      );
    } else {
      return const Badge(
        label: Text('任意'),
        backgroundColor: Colors.black,
      );
    }
  }
}
