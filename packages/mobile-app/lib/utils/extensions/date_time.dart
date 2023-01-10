import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 日本の曜日
  static const List<String> japaneseWeekdays = ['月', '火', '水', '木', '金', '土', '日'];

  /// 「2022-01-01 (月)」のような文字列に変換する
  String toYYYYMMDD({
    String delimiter = '-',
    bool withJapaneseWeekDay = true,
  }) =>
      withJapaneseWeekDay
          ? DateFormat('yyyy${delimiter}MM${delimiter}dd ($japaneseWeekDay)').format(this)
          : DateFormat('yyyy${delimiter}MM${delimiter}dd').format(this);

  /// 「2022年01月01日 (月)」のような文字列に変換する
  String toJaYYYYMMDD({bool withJapaneseWeekDay = true}) => withJapaneseWeekDay
      ? DateFormat('yyyy年MM月dd日 ($japaneseWeekDay)').format(this)
      : DateFormat('yyyy年MM月dd日').format(this);

  /// 「2022-01-01 (月) 00:00」のような文字列に変換する
  String toYYYYMMDDHHMM({
    String delimiter = '-',
    bool withJapaneseWeekDay = true,
  }) =>
      withJapaneseWeekDay
          ? DateFormat(
              'yyyy${delimiter}MM${delimiter}dd ($japaneseWeekDay) HH:mm',
            ).format(this)
          : DateFormat('yyyy${delimiter}MM${delimiter}dd HH:mm').format(this);

  /// 「2022年01月01日 (月) 00:00」のような文字列に変換する
  String toJaYYYYMMDDHHMM({bool withJapaneseWeekDay = true}) => withJapaneseWeekDay
      ? DateFormat('yyyy年MM月dd日 ($japaneseWeekDay) HH:mm').format(this)
      : DateFormat('yyyy年MM月dd日 HH:mm').format(this);

  /// 入力日の日本の曜日を返す
  String get japaneseWeekDay => japaneseWeekdays[_weekDayInt(this) - 1];

  /// 入力日の曜日を整数型で返す
  int _weekDayInt(DateTime dateTime) => dateTime.weekday;
}

/// yyyy-MM-dd (曜) の形式の文字列を返す
String toIsoStringDateWithWeekDay(DateTime? dateTime, [String placeHolder = '']) {
  if (dateTime == null) {
    return placeHolder;
  }
  return '${DateFormat('yyyy-MM-dd').format(dateTime)} '
      '(${dateTime.japaneseWeekDay})';
}

/// 24 時間制の時刻だけを返す
String to24HourNotationString(DateTime? dateTime) {
  return dateTime == null ? '' : DateFormat.Hm().format(dateTime);
}

/// 2 つの DateTime が同じ日かどうか判定する
bool sameDay(DateTime a, DateTime b) => a.difference(b).inDays == 0 && a.day == b.day;

/// - 今日と同じ日付なら 24 時間制の時刻の文字列を
/// - N 日前までなら「N 日前」の文字列を
/// - それより前なら yyyy-MM-dd の日付を
///
/// 返す
String humanReadableDateTimeString(
  DateTime? dateTime, [
  int daysDiffLimit = 7,
  String placeHolder = '',
]) {
  if (dateTime == null) {
    return placeHolder;
  }
  final now = DateTime.now();
  if (sameDay(dateTime, now)) {
    return DateFormat('HH:mm').format(dateTime);
  }
  // 今日の 00:00
  final todaysMidnight = DateTime(now.year, now.month, now.day);
  // 引数に渡した日の 00:00
  final midnight = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // 今日の 00:00 と引数に渡した日の 00:00 の日付差を取って
  // 「今日」「昨日」or「N 日前」の文字列を返す
  final daysDiff = todaysMidnight.difference(midnight).inDays.abs();
  if (daysDiff <= daysDiffLimit) {
    if (daysDiff == 0) {
      return '今日';
    }
    if (daysDiff == 1) {
      return '昨日';
    }
    return '$daysDiff 日前';
  }
  // 上記に該当しない場合は yyyy-MM-dd の日付を返す
  return DateFormat('yyyy-MM-dd').format(dateTime);
}
