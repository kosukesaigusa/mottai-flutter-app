import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/bottom_tab/bottom_tab.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/root_widget.dart';
import 'global_key.dart';

final restartAppProvider = Provider.autoDispose(
  (ref) => () async {
    try {
      await ref
          .read(sharedPreferencesServiceProvider)
          .saveLastActiveBottomTab(ref.read(bottomTabStateProvider));
    } finally {
      final context = ref.read(globalKeyProvider).currentContext!;
      await RootWidget.restart(context);
    }
  },
);
