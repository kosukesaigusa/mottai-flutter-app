import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {

  /// _daysBeforeメソッドで使用される定数。
  /// 「N日前」と表示される最小日数を示す。
  static const _daysBeforeLowerLimit = 2;

  /// _daysBeforeメソッドで使用される定数。
  /// 「N日前」と表示される最大日数を示す。
  static const _daysBeforeUpperLimit = 7;

  /// 「yyyy年MM月dd日」形式の文字列を返す。
  String formatDate() => DateFormat('yyyy年MM月dd日').format(this);

  /// 「yyyy年MM月dd日 HH時mm分」形式の文字列を返す。
  String formatDateTime() => DateFormat('yyyy年MM月dd日 HH時mm分').format(this);

  /// 現在時刻と比較して、相対的な日付文字列を返す。
  String formatRelativeDate() {
    final now = DateTime.now();
    if (_isToday()) {
      return DateFormat('HH:mm').format(this);
    }
    if (_isYesterday(now)) {
      return '昨日';
    }
    final daysBeforeResult = _daysBefore(now);
    if (daysBeforeResult != null) {
      return '$daysBeforeResult日前';
    }
    return formatDate();
  }

  /// thisが今日かどうかの真偽値を返す
  bool _isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// thisが昨日かどうかの真偽値を返す
  bool _isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// thisが、現在時刻と比較して
  /// [_daysBeforeLowerLimit] 日〜 [_daysBeforeUpperLimit] 日前ならその数字を、
  /// そうでなければnullを返す
  int? _daysBefore() {
    final now = DateTime.now();
    final difference = now.difference(this).inDays;
    if (difference >= _daysBeforeLowerLimit &&
        difference <= _daysBeforeUpperLimit) {
      return difference;
    }
    return null;
  }
}
