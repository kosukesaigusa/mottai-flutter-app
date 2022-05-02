import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/bottom_tabs.dart';

final bottomTabStateProvider = StateProvider<BottomTab>((_) => bottomTabs[0]);
