import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/bottom_tab/bottom_tab.dart';

final navigationServiceProvider = Provider.autoDispose(NavigationService.new);

/// 画面遷移の挙動を提供するクラス
class NavigationService {
  NavigationService(ProviderRef<NavigationService> ref) : _ref = ref;
  final ProviderRef<NavigationService> _ref;

  /// 現在アクティブな下タブに指定したパスのページを push する。
  Future<void> pushOnCurrentTab<T extends Object>({
    required String location,
    T? arguments,
  }) async =>
      _ref
          .read(bottomTabStateProvider)
          .key
          .currentState
          ?.pushNamed<void>(location, arguments: arguments);

  /// 一度 MainPage まで画面を pop した上で、
  /// 指定したタブをアクティブにして、その上で指定したパスのページを push する。
  /// 指定したパスが MainPage のいずれかのページのパスと一致する場合には push せず、
  /// そのタブをアクティブにするだけで終わりにする。
  void popUntilFirstRoute() {
    final currentContext = _ref.read(bottomTabStateProvider).key.currentContext;
    if (currentContext == null) {
      return;
    }
    Navigator.popUntil(currentContext, (route) => route.isFirst);
  }

  /// 一度 MainPage まで画面を pop した上で、
  /// 指定したタブをアクティブにして、その上で指定したパスのページを push する。
  /// 指定したパスが MainPage のいずれかのページのパスと一致する場合には push せず、
  /// そのタブをアクティブにするだけで終わりにする。
  Future<void> popUntilFirstRouteAndPushOnSpecifiedTab<T extends Object>({
    required BottomTab bottomTab,
    required String location,
    T? extra,
  }) async {
    final currentContext = _ref.read(bottomTabStateProvider).key.currentContext;
    if (currentContext == null) {
      return;
    }
    Navigator.popUntil(currentContext, (route) => route.isFirst);
    _ref.read(bottomTabStateProvider.notifier).update((state) => bottomTab);
    return _ref
        .read(bottomTabStateProvider)
        .key
        .currentState
        ?.pushNamed<void>(location, arguments: extra);
  }

  /// Android OS の戻るボタンでアプリが終了しないために、
  /// ウィジェットツリーの上部の WillPopScope ウィジェットで使用する。
  Future<bool> maybePop() async {
    final currentContext = _ref.read(bottomTabStateProvider).key.currentContext;
    if (currentContext == null) {
      return Future.value(false);
    }
    await Navigator.maybePop(currentContext);
    return false;
  }
}
