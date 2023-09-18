import 'package:auto_route/auto_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CrashlyticsPage extends StatelessWidget {
  const CrashlyticsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/crashlyticsTest';

  /// [CrashlyticsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseCrashlytics.instance.crash();
          },
          child: const Text('クラッシュさせてみる'),
        ),
      ),
    );
  }
}
