import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../exceptions/base.dart';
import '../logger.dart';

final appRouterStateProvider = Provider<AppRouterState>(
  (_) => throw const AppException(message: 'データが見つかりませんでした。'),
);

/// go_router パッケージの GoRouterState を参考にした
/// ルーティングに関するパスやパラメータを取り扱うクラス。
class AppRouterState {
  AppRouterState({
    required this.location,
    required this.name,
    this.fullpath,
    this.params = const <String, String>{},
    this.queryParams = const <String, String>{},
    this.extra,
  });

  /// 画面遷移時に RouteSettings.name に指定される実際のパス。
  /// e.g. /family/f2/person/p1?page=1
  final String location;

  /// ルートの名前
  final String? name;

  /// location を解析して一致するパスを探すためのパスパターン。
  /// path とか pathPattern とかいう名前でも良いかもしれないが、参考にしている
  /// GoRouterState.fullpath に合わせた名前とした
  /// e.g. /family/:familyId/person/:personId
  final String? fullpath;

  /// パスパラメータの <String, String> のマップ
  /// e.g. {'familyId': 'f1', 'personId': 'p1'}
  final Map<String, String> params;

  /// クエリパラメータの <String, String> マップ
  /// e.g. {'page': '1'}
  final Map<String, String> queryParams;

  /// パスパラメータ、クエリパラメータで指定できないその他のデータ。
  /// Navigator.pushNamed の引数 arguments に指定して使用する。
  final Object? extra;
}

/// AppRouterState.extra から指定した型のインスタンスを取り出すよう
/// 試みるメソッドを提供する Provider。
///
/// ```dart
/// // return Foo?
/// ref.read(extractExtraDataProvider)<Foo>()
/// ```
///
/// のようにして使用する。
final extractExtraDataProvider = Provider.autoDispose(
  (ref) => <T>() {
    final state = ref.read(appRouterStateProvider);
    try {
      final data = state.extra as T?;
      return data;
    } on Exception catch (e) {
      logger.info('AppRouteState.extra に指定したデータが見つかりませんでした：$e');
      return null;
      // ignore: avoid_catching_errors
    } on Error catch (e) {
      logger.info('AppRouteState.extra に指定したデータが見つかりませんでした：$e');
      return null;
    }
  },
  dependencies: <ProviderOrFamily>[appRouterStateProvider],
);
