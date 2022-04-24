import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';

import '../../providers/account/account.dart';
import '../../providers/account_page/account_page_controller.dart';
import '../../providers/auth/auth_providers.dart';
import '../../theme/theme.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';
import '../../widgets/common/loading.dart';
import '../../widgets/sign_in/sign_in_buttons.dart';

const double buttonHeight = 48;
const double buttonWidth = 240;

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const path = '/account/';
  static const name = 'AccountPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('AccountPage'),
              const Gap(16),
              ref.watch(accountStreamProvider).when<Widget>(
                    loading: () => const PrimarySpinkitCircle(),
                    error: (error, stackTrace) {
                      print(stackTrace);
                      return Text(error.toString());
                    },
                    data: (account) => account == null ? _notSignedInWidget : _signedInWidget,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  /// 未ログイン時のウィジェット
  Widget get _notSignedInWidget {
    return HookConsumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            _buildSocialLoginButtons,
            const Gap(16),
            Text(
              '上記のソーシャルアカウントでログインすることができます。'
              'または、以下のボタンを押してテスト用ホストアカウントとして'
              'ログインすることができます。',
              style: grey12,
            ),
            const Gap(16),
            SizedBox(
              height: 36,
              width: 220,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(accountPageController.notifier).signInWithEmailAndPassword(
                        email: const String.fromEnvironment('HOST_1_EMAIL'),
                        password: const String.fromEnvironment('HOST_1_PASSWORD'),
                      );
                },
                child: const Text('ホスト 1'),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ログイン済みのウィジェット
  Widget get _signedInWidget {
    return HookConsumer(builder: (context, ref, child) {
      return Column(
        children: [
          _buildProfileImageWidget,
          const Gap(16),
          _buildDisplayNameWidget,
          const Gap(8),
          ElevatedButton.icon(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await auth.signOut();
              RootWidget.restart(context);
            },
            label: const Text('サインアウトする'),
          ),
          _buildSocialLoginButtons,
        ],
      );
    });
  }

  /// プロフィール画像のウィジェット
  Widget get _buildProfileImageWidget {
    return HookConsumer(
      builder: (context, ref, child) {
        return ref.watch(accountStreamProvider).when<Widget>(
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
              data: (account) {
                return CircleImage(
                  size: 64,
                  imageURL: account?.imageURL,
                );
              },
            );
      },
    );
  }

  /// 表示名のウィジェット
  Widget get _buildDisplayNameWidget {
    return HookConsumer(
      builder: (context, ref, child) {
        return ref.watch(accountStreamProvider).when<Widget>(
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
              data: (account) {
                if (account == null) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    Text('こんにちは、${account.displayName} さん。'),
                    const Gap(8),
                    Text('User ID: ${(ref.watch(userIdProvider).value ?? '-').substring(0, 8)}...'),
                    const Gap(8),
                    _buildConnectedSocialAccounts,
                  ],
                );
              },
            );
      },
    );
  }

  /// 連携済みソーシャルログインのカラムを返す
  Widget get _buildConnectedSocialAccounts {
    return HookConsumer(
      builder: (context, ref, child) {
        return ref.watch(accountStreamProvider).when<Widget>(
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
              data: (account) {
                if (account == null) {
                  return const SizedBox();
                }
                final providers = account.providers;
                return Column(
                  children: [
                    if (providers.contains(SocialSignInMethod.Google.name)) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.google,
                            size: 12,
                            color: Color(0xff3369E8),
                          ),
                          Gap(8),
                          Text(
                            'Google 連携済み',
                            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
                          ),
                        ],
                      ),
                      const Gap(8),
                    ],
                    if (providers.contains(SocialSignInMethod.Apple.name)) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.apple,
                            size: 16,
                            color: Colors.black,
                          ),
                          Gap(8),
                          Text(
                            'Apple 連携済み',
                            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
                          ),
                        ],
                      ),
                      const Gap(8),
                    ],
                    if (providers.contains(SocialSignInMethod.LINE.name))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.line,
                            size: 16,
                            color: Color(0xff00ba52),
                          ),
                          Gap(8),
                          Text(
                            'LINE 連携済み',
                            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
                          ),
                        ],
                      ),
                  ],
                );
              },
            );
      },
    );
  }

  /// ソーシャルログインボタンのカラムを返す
  Widget get _buildSocialLoginButtons {
    return HookConsumer(
      builder: (context, ref, child) {
        return ref.watch(accountStreamProvider).when<Widget>(
              loading: () => const SizedBox(),
              error: (error, stackTrace) => const SizedBox(),
              data: (account) {
                if (account == null) {
                  return Column(
                    children: const [
                      SocialSignInButton(method: SocialSignInMethod.Google),
                      Gap(8),
                      SocialSignInButton(method: SocialSignInMethod.Apple),
                      Gap(8),
                      SocialSignInButton(method: SocialSignInMethod.LINE),
                    ],
                  );
                }
                final providers = account.providers;
                final isHost = account.isHost;
                return isHost
                    ? const SizedBox()
                    : Column(
                        children: [
                          if (!setEquals(
                            providers.toSet(),
                            SocialSignInMethod.values.map((e) => e.name).toSet(),
                          ))
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(children: [
                                const Expanded(child: Divider()),
                                const Gap(16),
                                Text('他のログイン方法と連携する', style: grey12),
                                const Gap(16),
                                const Expanded(child: Divider()),
                              ]),
                            ),
                          if (!providers.contains(SocialSignInMethod.Google.name))
                            const SocialSignInButton(method: SocialSignInMethod.Google),
                          if (!providers.contains(SocialSignInMethod.Apple.name))
                            const SocialSignInButton(method: SocialSignInMethod.Apple),
                          if (!providers.contains(SocialSignInMethod.LINE.name))
                            const SocialSignInButton(method: SocialSignInMethod.LINE),
                        ],
                      );
              },
            );
      },
    );
  }
}
