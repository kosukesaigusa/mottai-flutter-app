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

  /// thisと現在時刻と比較して相対的な日付文字列を返す。
  /// thisが今日であれば、「HH:mm」
  /// 昨日であれば、「昨日」
  /// _daysBeforeLowerLimitから_daysBeforeUpperLimitの範囲内であれば、「N日前」
  /// それ以外は 'yyyy年MM月dd日' 形式の日付
  String formatRelativeDate() {
    if (_isToday()) {
      return DateFormat('HH:mm').format(this);
    }
    if (_isYesterday()) {
      return '昨日';
    }
    final daysBeforeResult = _daysBefore();
    if (daysBeforeResult != null) {
      return '$daysBeforeResult日前';
    }
    return formatDate();
  }

  /// thisが今日かどうかの真偽値を返す。
  /// thisと現在時刻の「年、月、日」が全て一致する場合には「今日」であるため真を返す。
  bool _isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// thisが昨日かどうかの真偽値を返す。
  /// thisと現在の日付より1日前の「年、月、日」が全て一致する場合には「昨日」であるため真を返す。
  bool _isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// thisと現在時刻との間の日数を計算し、
  /// その日数が[_daysBeforeLowerLimit] 日〜 [_daysBeforeUpperLimit] 日の範囲内ならその数字を、
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
