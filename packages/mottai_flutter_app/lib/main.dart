import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';
import 'package_info.dart';
import 'router/router.dart';
import 'scaffold_messenger_controller.dart';
import 'user/user.dart';
import 'user/user_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer();
  final hostDocumentExists =
      await container.read(hostDocumentExistsProvider).call();
  container.dispose();
  runApp(
    ProviderScope(
      overrides: [
        packageInfoProvider.overrideWithValue(await PackageInfo.fromPlatform()),
        userModeStateProvider.overrideWith(
          (ref) => hostDocumentExists ? UserMode.host : UserMode.worker,
        ),
      ],
      child: const MainApp(),
    ),
  );
}

final _appRouterProvider = Provider.autoDispose<AppRouter>((_) => AppRouter());

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MOTTAI',
      theme: ThemeData(
        useMaterial3: true,
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              elevation: 4,
              shadowColor: Theme.of(context).shadowColor,
            ),
        chipTheme: Theme.of(context).chipTheme.copyWith(
              backgroundColor: const Color(0xFFE8DEF8),
            ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(_appRouterProvider).config(),
      // NOTE:
      // scaffoldMessengerKey はここで指定しても正しく動かなかった。
      // 代わりに builder の中で下記のように指定しているが、本当に正しいかどうか、予期しない
      // 仕様になっていないかは不明。ひとまず SampleTodoPage で SnackBar, AlertDialog の
      // 表示の機能は問題なく動いている。
      // scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      builder: (context, child) {
        return Navigator(
          key: ref.watch(navigatorKeyProvider),
          onPopPage: (route, dynamic _) => false,
          pages: [
            MaterialPage<Widget>(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: ScaffoldMessenger(
                      key: ref.watch(scaffoldMessengerKeyProvider),
                      child: child!,
                    ),
                  ),
                  // if (isLoading) const OverlayLoading(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
