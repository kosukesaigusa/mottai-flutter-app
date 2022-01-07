import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/app.dart';
import 'package:mottai_flutter_app/gen/firebase_options_dev.dart' as dev;
import 'package:mottai_flutter_app/gen/firebase_options_prod.dart' as prod;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR');
  await Firebase.initializeApp(options: getFirebaseOptions(flavor));
  if (flavor == 'local') {
    await setUpLocalEmulator();
  }
  runApp(const App());
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
