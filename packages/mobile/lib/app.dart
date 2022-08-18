import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/localization.dart';
import 'constants/string.dart';
import 'pages/root_navigator.dart';
import 'utils/extensions/build_context.dart';

/// MaterialApp を返すウィジェット。
/// ここではルートは制御せず、home プロパティに
/// RootNavigator を指定するだけとする。
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(),
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: const <Locale>[locale],
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.blue).copyWith(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: const TextStyle(color: Colors.black87),
          iconTheme: IconThemeData(color: ThemeData().primaryColor),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black87,
        ),
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
        sliderTheme: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
      ),
      home: const RootNavigator(),
      builder: (context, child) {
        return MediaQuery(
          // 端末依存のフォントスケールを 1 に固定する
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
    );
  }
}
