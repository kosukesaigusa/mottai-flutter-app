import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'utils/firebase_local_emulator.dart';
import 'utils/provider_scope.dart';
import 'widgets/root_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialize();
  // 画面の向きを固定する
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final overrides = await providerScopeOverrides;
  runApp(RootWidget(overrides: overrides));
}

/// 各種サービス関係での初期化処理を行う。
Future<void> initialize() async {
  await Future.wait<void>([
    if (const String.fromEnvironment('FLAVOR') == 'local') setUpLocalEmulator(),
    LineSDK.instance.setup(const String.fromEnvironment('LINE_CHANNEL_ID')),
  ]);
}
