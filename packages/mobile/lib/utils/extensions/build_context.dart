import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// テーマ
  ThemeData get theme => Theme.of(this);

  /// テキストのテーマ
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// ディスプレイサイズ
  Size get displaySize => MediaQuery.of(this).size;
}
