import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/map/map.dart';
import 'firebase_messaging.dart';
import 'shared_preferences.dart';

/// RootProviderScope で指定する List<Override> を取得する。
Future<List<Override>> get providerScopeOverrides async {
  return <Override>[
    sharedPreferencesProvider.overrideWithValue(
      await SharedPreferences.getInstance(),
    ),
    firebaseMessagingProvider.overrideWithValue(
      await getFirebaseMessagingInstance,
    ),
    initialCenterLatLngProvider.overrideWithValue(await initialCenterLatLng),
  ];
}
