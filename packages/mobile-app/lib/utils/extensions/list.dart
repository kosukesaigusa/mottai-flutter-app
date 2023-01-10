import 'dart:math';

extension ListExtension<T> on List<T> {
  /// List<dynamic> を List<Map<String, dynamic>> に変換する。
  /// List<dynamic> を as List<Map<String, dynamic>> で変換できないため。
  List<Map<String, dynamic>> get toMaps {
    final maps = <Map<String, dynamic>>[];
    for (final e in this) {
      if (e == null) {
        continue;
      }
      try {
        maps.add(e as Map<String, dynamic>);
      } on Exception {
        continue;
        // ignore: avoid_catching_errors
      } on Error {
        continue;
      }
    }
    return maps;
  }

  /// リストからランダムに要素をひとつ選んで返す。
  T get random => this[Random().nextInt(length)];

  /// 指定した index 番号の要素を返す。
  /// index が存在せず RangeError を起こす場合は null を返す。
  T? getByIndexOrNull(int index) {
    try {
      return this[index];
      // ignore: avoid_catching_errors
    } on RangeError {
      return null;
    }
  }
}
