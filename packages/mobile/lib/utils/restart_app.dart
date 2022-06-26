import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/bottom_tab/bottom_tab.dart';
import '../services/scaffold_messenger_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/root/root_widget.dart';

final restartAppProvider = Provider.autoDispose(
  (ref) => () async {
    try {
      await ref
          .read(sharedPreferencesServiceProvider)
          .saveLastActiveBottomTab(ref.read(bottomTabStateProvider));
    } finally {
      final context = ref.read(scaffoldMessengerServiceProvider).navigatorKey.currentContext!;
      await RootWidget.restart(context);
    }
  },
);
