extension MapExtension on Map<String, dynamic>? {
  /// Map<String, dynamic>? から特定の Key の Value を取得する
  ///
  /// - this のインスタンスが null の場合は null
  /// - [ignoreError] が true の場合 null
  /// - [ignoreError] が false の場合 Exception
  /// - キャストできない場合は null
  ///
  /// が返される。
  T? getByKey<T extends Object?>(String key, {bool ignoreError = true}) {
    if (this == null) {
      return null;
    }
    if (!this!.containsKey(key)) {
      if (ignoreError) {
        return null;
      }
      throw Exception('MapExtensionError: $key does not exist.');
    }
    try {
      return this![key] as T;
      // ignore: avoid_catching_errors
    } on Error {
      return null;
    }
  }
}
