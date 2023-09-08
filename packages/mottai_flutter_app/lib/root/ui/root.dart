import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../assets.dart';
import '../../auth/auth.dart';
import '../../auth/ui/auth_controller.dart';
import '../../auth/ui/auth_dependent_builder.dart';
import '../../development/development_items/ui/development_items.dart';
import '../../development/disable_user_account_request/ui/disable_user_account_request_controller.dart';
import '../../development/email_and_password_sign_in/ui/email_and_password_sign_in.dart';
import '../../development/sign_in/ui/sign_in.dart';
import '../../package_info.dart';
import '../../push_notification/firebase_messaging.dart';
import '../../router/router.gr.dart';
import '../../scaffold_messenger_controller.dart';
import '../../user/user.dart';
import '../../user/user_mode.dart';

final rootPageKey = Provider((ref) => GlobalKey<NavigatorState>());

/// メインの [BottomNavigationBar] を含む画面。
@RoutePage()
class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/';

  /// [RootPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  void initState() {
    super.initState();
    Future.wait<void>([
      ref.read(initializeFirebaseMessagingProvider)(),
      ref.read(getFcmTokenProvider)(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      key: ref.watch(rootPageKey),
      appBarBuilder: (_, __) => AppBar(
        title: Image.asset(MottaiAssets.appBarLogo, height: 40),
      ),
      drawer: const Drawer(child: _DrawerChild()),
      routes: const [
        MapRoute(),
        ChatRoomsRoute(),
        ReviewsRoute(),
        MyAccountRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '探す',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'チャット',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: '感想',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'アカウント',
            ),
          ],
        );
      },
    );
  }
}

class _DrawerChild extends ConsumerWidget {
  const _DrawerChild();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${packageInfo.packageName} '
                '(${packageInfo.version}+${packageInfo.buildNumber})',
              ),
              if (ref.watch(isHostProvider)) ...[
                const Gap(8),
                Text(
                  'ユーザーモード',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                ToggleButtons(
                  onPressed: (index) {
                    final notifier = ref.read(userModeStateProvider.notifier);
                    if (index == 0) {
                      notifier.update((_) => UserMode.worker);
                    } else if (index == 1) {
                      notifier.update((_) => UserMode.host);
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  constraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 80,
                  ),
                  isSelected: UserMode.values
                      .map((mode) => mode == ref.watch(userModeStateProvider))
                      .toList(),
                  children: UserMode.values
                      .map((userMode) => Text(userMode.name))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        if (ref.watch(isSignedInProvider)) ...[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(ref.watch(userIdProvider)!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('サインアウト'),
            onTap: () => ref.read(authControllerProvider).signOut(),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('サインイン（メールアドレスとパスワード）'),
            onTap: () =>
                context.router.pushNamed(EmailAndPasswordSignInPage.location),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('サインイン（ソーシャル）'),
            onTap: () => context.router.pushNamed(SignInSamplePage.location),
          )
        ],
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('FCM トークン表示'),
          onTap: () async {
            final token = await ref.read(getFcmTokenProvider).call();
            if (token == null) {
              return;
            }
            debugPrint(token);
            await ref
                .read(appScaffoldMessengerControllerProvider)
                .showDialogByBuilder<void>(
                  builder: (context) => AlertDialog(
                    title: const SelectableText('FCM トークン'),
                    content: Text(token),
                  ),
                );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('開発ページへ'),
          onTap: () => context.router.pushNamed(DevelopmentItemsPage.location),
        ),
        AuthDependentBuilder(
          onAuthenticated: (userId) => ListTile(
            leading: const Icon(Icons.person_off),
            title: const Text('退会する'),
            onTap: () async {
              await ref
                  .read(disableUserAccountRequestControllerProvider)
                  .disableUserAccountRequest(
                    userId: userId,
                  );
            },
          ),
          onUnAuthenticated: () => const SizedBox(),
        ),
      ],
    );
  }
}
