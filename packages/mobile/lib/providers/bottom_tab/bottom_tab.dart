import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/bottom_tabs.dart';

/// 現在選択状態になっている下タブを管理する StateProvider。
final bottomTabStateProvider = StateProvider<BottomTab>((_) => bottomTabs[0]);
