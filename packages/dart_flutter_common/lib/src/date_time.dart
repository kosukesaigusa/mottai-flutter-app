import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 「yyyy年MM月dd日」形式の文字列を返す。
  String formatDate() => DateFormat('yyyy年MM月dd日').format(this);

  /// 「yyyy年MM月dd日 HH時mm分」形式の文字列を返す。
  String formatDateTime() => DateFormat('yyyy年MM月dd日 HH時mm分').format(this);

  /// 現在時刻と比較して、相対的な日付文字列を返す。
  String formatRelativeDate() {
    final now = DateTime.now();
    if (_isToday(now)) {
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

  bool _isToday(DateTime now) {
    return year == now.year && month == now.month && day == now.day;
  }

  bool _isYesterday(DateTime now) {
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// 現在と比較して2日〜7日前ならその数字を、そうでなければnullを返す
  int? _daysBefore(DateTime now) {
    final difference = now.difference(this).inDays;
    if (difference >= 2 && difference <= 7) {
      return difference;
    }
    return null;
  }
}
