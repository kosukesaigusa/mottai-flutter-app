import 'package:intl/intl.dart';

final _threeDigitsFormatter = NumberFormat('#,###');

extension IntExtension on int {
  /// 3 桁区切りのコンマを付加する。
  String get withComma => _threeDigitsFormatter.format(this);
}
