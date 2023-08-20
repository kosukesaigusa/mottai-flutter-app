import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';
import 'package_info.dart';
import 'push_notification/firebase_messaging.dart';
import 'router/router.dart';
import 'scaffold_messenger_controller.dart';
import 'setup_local_emulator.dart';
import 'user/user.dart';
import 'user/user_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (const String.fromEnvironment('FLAVOR') == 'local') {
    await setUpLocalEmulator();
  }
  await LineSDK.instance
      .setup(const String.fromEnvironment('LINE_CHANNEL_ID'))
      .then((_) {
    debugPrint('LineSDK Prepared');
  });
  final container = ProviderContainer();
  final hostDocumentExists =
      await container.read(hostDocumentExistsProvider).call();
  container.dispose();
  runApp(
    ProviderScope(
      overrides: [
        packageInfoProvider.overrideWithValue(await PackageInfo.fromPlatform()),
        firebaseMessagingProvider
            .overrideWithValue(await getFirebaseMessagingInstance()),
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
              centerTitle: true,
              elevation: 4,
              shadowColor: Theme.of(context).shadowColor,
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
