/// 月の列挙。
enum Month {
  jan(value: 1, label: '1月'),
  feb(value: 2, label: '2月'),
  mar(value: 3, label: '3月'),
  apr(value: 4, label: '4月'),
  may(value: 5, label: '5月'),
  jun(value: 6, label: '6月'),
  jul(value: 7, label: '7月'),
  aug(value: 8, label: '8月'),
  sep(value: 9, label: '9月'),
  oct(value: 10, label: '10月'),
  nov(value: 11, label: '11月'),
  dec(value: 12, label: '12月');

  const Month({
    required this.value,
    required this.label,
  });

  /// 月の値
  final int value;

  /// 表示する内容
  final String label;

  /// 指定した整数値が月として有効かどうか
  static bool isValidMonth(int month) => values.map((e) => e.value).toList().contains(month);
}
