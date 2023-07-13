import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 「yyyy年MM月dd日」形式の文字列を返す。
  String formatDate() => DateFormat('yyyy年MM月dd日').format(this);

  /// 「yyyy年MM月dd日 HH時mm分」形式の文字列を返す。
  String formatDateTime() => DateFormat('yyyy年MM月dd日 HH時mm分').format(this);
}
