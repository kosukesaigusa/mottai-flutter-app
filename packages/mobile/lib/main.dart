import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/app.dart';
import 'package:mottai_flutter_app/gen/firebase_options_dev.dart' as dev;
import 'package:mottai_flutter_app/gen/firebase_options_prod.dart' as prod;
import 'package:mottai_flutter_app/services/firebase_messaging_service.dart';
import 'package:mottai_flutter_app/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (const String.fromEnvironment('FLAVOR') == 'local') {
    await setUpLocalEmulator();
  }
  // 画面の向きを固定
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initialize();
  runApp(
    const RootWidget(
      child: ProviderScope(
        child: App(),
      ),
    ),
  );
}

/// 接続する Firebase プロジェクトを決定する。
FirebaseOptions getFirebaseOptions(String flavor) {
  switch (flavor) {
    case 'local':
      return dev.DefaultFirebaseOptions.currentPlatform;
    case 'dev':
      return dev.DefaultFirebaseOptions.currentPlatform;
    case 'prod':
      return prod.DefaultFirebaseOptions.currentPlatform;
    default:
      throw AssertionError('--dart-define flavor: $flavor is not supported.');
  }
}

/// 各種サービス関係での初期化処理を行う。
Future<void> initialize() async {
  await Future.wait([
    SharedPreferencesService.initialize(),
    FirebaseMessagingService.initialize(),
  ]);
}
