extension ListExtension on List {
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
}
