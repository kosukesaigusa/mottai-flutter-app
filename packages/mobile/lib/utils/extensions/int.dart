import 'package:intl/intl.dart';

final _threeDigitsFormatter = NumberFormat('#,###');

extension IntExtension on int {
  /// 3 桁区切りのコンマを付加する。
  String get withComma => _threeDigitsFormatter.format(this);

  /// 数字に 3 桁区切りのコンマを付加、末尾に「円」を付けた文字列を返す。
  String toJpy(int number) => '${_threeDigitsFormatter.format(number)} 円';
}
