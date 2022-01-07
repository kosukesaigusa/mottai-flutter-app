import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/app.dart';
import 'package:mottai_flutter_app/app_multi_providers.dart';
import 'package:mottai_flutter_app/gen/firebase_options_dev.dart' as dev;
import 'package:mottai_flutter_app/gen/firebase_options_prod.dart' as prod;
import 'package:mottai_flutter_app/services/firebase_messaging_service.dart';
import 'package:mottai_flutter_app/services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR');
  await Firebase.initializeApp(options: getFirebaseOptions(flavor));
  if (flavor == 'local') {
    await setUpLocalEmulator();
  }
  await initialize();
  runApp(
    const RootWidget(
      child: AppMultiProvider(
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
    SharedPreferencesService.init(),
    FirebaseMessagingService.initialize(),
  ]);
}
