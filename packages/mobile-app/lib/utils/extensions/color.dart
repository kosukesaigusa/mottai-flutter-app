import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// 輝度に応じて黒か白かを返す。
  Color get onPrimary => computeLuminance() < 0.5 ? Colors.white : Colors.black;
}
