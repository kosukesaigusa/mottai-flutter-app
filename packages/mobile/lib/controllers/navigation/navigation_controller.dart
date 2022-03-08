import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/dynamic_links.dart';
import '../../route/utils.dart';
import '../../utils/utils.dart';
import '../application/application_controller.dart';
import '../bottom_navigation_bar/bottom_navigation_bar_controller.dart';

final navigationController = Provider.autoDispose((ref) => NavigationController(ref.read));

class NavigationController {
  NavigationController(this._reader);

  final Reader _reader;

  /// 通知や Dynamic Links によって現在のタブ上で画面遷移する
  Future<void> pushOnCurrentTab({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final currentTab = _reader(bottomNavigationBarController).currentTab;
    final navigatorKey = _reader(applicationController.notifier).navigatorKeys[currentTab];
    await navigatorKey?.currentState?.pushNamed<void>(path, arguments: RouteArguments(data));
  }

  /// Dynamic Links によって現在のタブ上で画面遷移する
  Future<void> navigateByDynamicLink(Uri uri) async {
    if (!allowedDynamicLinkHosts.contains(uri.host)) {
      return;
    }
    final p = uri.path;
    if (p.isEmpty) {
      return;
    }
    final path = normalizePathString(p);
    if (path.isEmpty) {
      return;
    }
    await pushOnCurrentTab(path: path, data: <String, dynamic>{});
  }
}
