import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_messaging_service.dart';
import '../services/shared_preferences_service.dart';

/// RootProviderScope で指定する List<Override> を取得する。
Future<List<Override>> get providerScopeOverrides async {
  return <Override>[
    sharedPreferencesProvider.overrideWithValue(
      await SharedPreferences.getInstance(),
    ),
    fcmProvider.overrideWithValue(
      await getFirebaseMessagingInstance,
    ),
  ];
}
