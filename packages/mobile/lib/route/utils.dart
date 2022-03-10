import '../utils/types.dart';

class RouteArguments {
  RouteArguments(this.data);

  final Map<String, dynamic> data;

  dynamic operator [](String key) => data[key];
}

/// パス文字列と対応するウィジェットを返すビルダーからなる
/// ルートに関するクラス。
class AppRoute {
  AppRoute(this.path, this.pageBuilder);

  final String path;
  final PageBuilder pageBuilder;
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException(this._path);
  final String _path;

  @override
  String toString() => '$_path：指定されたパスが見つかりませんでした。';
}
