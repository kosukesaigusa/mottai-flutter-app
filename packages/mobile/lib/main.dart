import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'services/firebase_messaging_service.dart';
import 'services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();
  // 画面の向きを固定する
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    RootWidget(
      child: ProviderScope(
        // ProviderScope の overrides したい Provider やその値を列挙する。
        // 起動時に一回インスタンス化したキャッシュを使いませせるようにすることで、
        // それ以降 await なしでアクセスしたいときなどに便利。
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
          fcmProvider.overrideWithValue(
            await getFirebaseMessagingInstance,
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

/// 各種サービス関係での初期化処理を行う。
Future<void> initialize() async {
  await Future.wait([
    if (const String.fromEnvironment('FLAVOR') == 'local') setUpLocalEmulator(),
    LineSDK.instance.setup(const String.fromEnvironment('LINE_CHANNEL_ID')),
  ]);
}
