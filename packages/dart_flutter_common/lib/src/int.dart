import 'package:intl/intl.dart';

final _threeDigitsFormatter = NumberFormat('#,###');

/// [int] 型の拡張クラス。
extension IntExtension on int {
  /// 3 桁区切りのコンマを付加する。
  String get withComma => _threeDigitsFormatter.format(this);
}
