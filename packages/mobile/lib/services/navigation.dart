import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/dynamic_links.dart';
import '../providers/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../route/main_tabs.dart';
import '../route/utils.dart';
import '../utils/utils.dart';

final navigationServiceProvider =
    Provider.autoDispose<NavigationService>((ref) => NavigationService(ref.read));

class NavigationService {
  NavigationService(this._read);

  final Reader _read;

  /// 現在アクティブな下タブに指定したパスのページを push する。
  Future<void> pushOnCurrentTab({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final currentBottomTab = _read(bottomNavigationBarStateNotifier).currentBottomTab;
    await currentBottomTab.key.currentState?.pushNamed<void>(path, arguments: RouteArguments(data));
  }

  /// 一度 MainPage まで画面を pop した上で、
  /// 指定したタブをアクティブにして、その上で指定したパスのページを push する。
  /// 指定したパスが MainPage のいずれかのページのパスと一致する場合には push せず、
  /// そのタブをアクティブにするだけで終わりにする。
  Future<void> popUntilFirstRouteAndPushOnSpecifiedTab({
    required BottomTab bottomTab,
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final currentContext =
        _read(bottomNavigationBarStateNotifier).currentBottomTab.key.currentContext;
    if (currentContext == null) {
      return;
    }
    Navigator.popUntil(currentContext, (route) => route.isFirst);
    _read(bottomNavigationBarStateNotifier.notifier).changeTab(bottomTab);
    if (!bottomTabs.map((bottomTab) => bottomTab.path).toList().contains(path)) {
      await bottomTab.key.currentState?.pushNamed<void>(path, arguments: RouteArguments(data));
    }
  }

  /// Dynamic Links などで Uri を指定して現在のタブ上で画面遷移する。
  Future<void> navigateOnCurrentTabByUri(Uri uri) async {
    final path = _getNormalizedPathString(uri);
    if (path.isEmpty) {
      return;
    }
    await pushOnCurrentTab(path: path, data: <String, dynamic>{});
  }

  /// Dynamic Links によって（Uri を指定して）、
  /// 一度 MainPage まで画面を pop した上で、
  /// 指定したタブをアクティブにして、その上で画面遷移する。
  Future<void> popUntilFirstRouteAndPushOnSpecifiedTabByUri(Uri uri) async {
    final path = _getNormalizedPathString(uri);
    if (path.isEmpty) {
      return;
    }
    final data = _getDataFromQueryParameters(uri);
    final tabName = (data['tab'] ?? BottomTabEnum.home.name) as String;
    final bottomTab = BottomTab.fromString(tabName);
    debugPrint('***');
    debugPrint('Dynamic Link (path, tab) = ($path, $tabName)');
    debugPrint('***');
    // TODO: DeepLink のクエリパラメータなどから data（画面の引数）を受け取れる仕組みを考える
    await popUntilFirstRouteAndPushOnSpecifiedTab(bottomTab: bottomTab, path: path, data: data);
  }

  /// 画面遷移のための Uri を検証して、ノーマライズした path (String) を返す。
  /// 何らかの問題があれば空文字が返される。
  String _getNormalizedPathString(Uri uri) {
    if (!allowedDynamicLinkHosts.contains(uri.host)) {
      return '';
    }
    final p = uri.path;
    if (p.isEmpty) {
      return '';
    }
    final path = normalizePathString(p);
    if (path.isEmpty) {
      return '';
    }
    return path;
  }

  // /// 受け取った Uri のクエリパラメタを検証して、Map<String, dynamic> を返す
  Map<String, dynamic> _getDataFromQueryParameters(Uri uri) {
    final queryParameters = uri.queryParameters;
    return queryParameters;
  }
}
