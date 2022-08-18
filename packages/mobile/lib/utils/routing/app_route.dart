import 'types.dart';

/// go_router パッケージに GoRoute を参考に、簡易にしたクラス。
class AppRoute {
  AppRoute({
    required this.path,
    required this.name,
    required this.builder,
    this.pageRoute,
  });

  /// ルートの名前
  final String name;

  /// ルートのパスパターン
  /// e.g. /family/:familyId/person/:personId
  final String path;

  /// ウィジェットビルダー
  final AppRouterWidgetBuilder builder;

  /// ページビルダー
  final AppRouterPageRoute? pageRoute;
}
