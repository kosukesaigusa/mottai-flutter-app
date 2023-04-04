import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
import 'utils/extensions/build_context.dart';
import 'utils/firebase_messaging.dart';
import 'utils/routing/root_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定する。
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Firebase を初期化する。
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      overrides: <Override>[
        firebaseMessagingProvider.overrideWithValue(
          await getFirebaseMessagingInstance,
        ),
        // initialCenterLatLngProvider.overrideWithValue(await initialCenterLatLng),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        /// Android のステータスバーアイコンの色が変更される
        statusBarIconBrightness: Brightness.light,

        /// iOS のステータスバーの文字色が変更される
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        key: UniqueKey(),
        title: 'NPO MOTTAI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange).copyWith(
          textTheme: TextTheme(
            displayLarge: context.textTheme.displayLarge!.copyWith(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
            displayMedium: context.textTheme.displayMedium!.copyWith(
              color: Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            displaySmall: context.textTheme.displaySmall!.copyWith(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: context.textTheme.headlineLarge!.copyWith(
              color: Colors.black54,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            headlineMedium: context.textTheme.headlineMedium!.copyWith(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            headlineSmall: context.textTheme.headlineSmall!.copyWith(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: context.textTheme.titleLarge!.copyWith(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: context.textTheme.titleMedium!.copyWith(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: context.textTheme.titleSmall!.copyWith(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: context.textTheme.bodyLarge!.copyWith(
              color: Colors.black87,
              fontSize: 16,
            ),
            bodyMedium: context.textTheme.bodyMedium!.copyWith(
              color: Colors.black87,
              fontSize: 14,
            ),
            bodySmall: context.textTheme.bodySmall!.copyWith(
              color: Colors.black87,
              fontSize: 12,
            ),
            labelLarge: context.textTheme.labelLarge!.copyWith(
              color: Colors.black54,
              fontSize: 16,
            ),
            labelMedium: context.textTheme.labelMedium!.copyWith(
              color: Colors.black54,
              fontSize: 14,
            ),
            labelSmall: context.textTheme.labelSmall!.copyWith(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          cardTheme: const CardTheme(margin: EdgeInsets.zero),
          scaffoldBackgroundColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black12,
          ),
        ),
        home: const RootNavigator(),
        builder: (context, child) {
          return MediaQuery(
            // 端末依存のフォントスケールを 1 に固定
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!,
          );
        },
      ),
    );
  }
}
