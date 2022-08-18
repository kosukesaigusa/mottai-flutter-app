import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/account/account.dart';
import '../features/auth/auth.dart';
import '../features/auth/auth_service.dart';
import '../utils/enums.dart';
import '../utils/extensions/build_context.dart';
import '../utils/extensions/string.dart';
import '../widgets/image.dart';
import '../widgets/loading.dart';
import '../widgets/sign_in_buttons.dart';

/// アカウントページ
class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  static const path = '/account';
  static const name = 'AccountPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('アカウント')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: ref.watch(accountProvider).when(
                data: (account) => account == null ? const GuestInWidget() : const SignedInWidget(),
                error: (_, __) => const SizedBox(),
                loading: () => const PrimarySpinkitCircle(),
              ),
        ),
      ),
    );
  }
}

/// 未ログイン時のウィジェット。
class GuestInWidget extends HookConsumerWidget {
  const GuestInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SocialLoginButtons(),
        const Gap(16),
        Text(
          '上記のソーシャルアカウントでログインすることができます。'
          'または、以下のボタンを押してテスト用ホストアカウントとして'
          'ログインすることができます。',
          style: context.bodySmall,
        ),
        const Gap(16),
        SizedBox(
          height: 36,
          width: 220,
          child: ElevatedButton(
            onPressed: () => ref.read(signInWithEmailAndPasswordProvider)(
              email: const String.fromEnvironment('HOST_1_EMAIL'),
              password: const String.fromEnvironment('HOST_1_PASSWORD'),
            ),
            child: const Text('ホスト 1'),
          ),
        ),
      ],
    );
  }
}

/// サインイン済み時のウィジェット。
class SignedInWidget extends HookConsumerWidget {
  const SignedInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ref.watch(accountProvider).when(
              data: (account) => CircleImageWidget(diameter: 64, imageURL: account?.imageURL),
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox(),
            ),
        const Gap(16),
        ref.watch(accountProvider).when(
              data: (account) {
                if (account == null) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    Text('こんにちは、${account.displayName} さん。'),
                    const Gap(8),
                    Text('User ID: ${(ref.watch(userIdProvider).value ?? '-').truncated(8)}'),
                    const Gap(8),
                    const ConnectedSocialAccountsWidget(),
                  ],
                );
              },
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox(),
            ),
        const Gap(8),
        ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => ref.read(authServiceProvider).signOut(),
          label: const Text('サインアウトする'),
        ),
        const SocialLoginButtons(),
      ],
    );
  }
}

/// ソーシャルログインのボタン一覧のウィジェット。
class SocialLoginButtons extends HookConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(accountProvider).when(
          data: (account) {
            if (account == null) {
              return Column(
                children: [
                  for (final method in SocialSignInMethod.values) ...[
                    SocialSignInButton(method: method),
                    const Gap(8),
                  ],
                ],
              );
            }
            final providers = account.providers;
            final isHost = account.isHost;
            if (isHost) {
              return const SizedBox();
            }
            return Column(
              children: [
                if (!setEquals(
                  providers.toSet(),
                  SocialSignInMethod.values.map((e) => e.name).toSet(),
                ))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        const Expanded(child: Divider()),
                        const Gap(16),
                        Text('他のログイン方法と連携する', style: context.bodySmall),
                        const Gap(16),
                        const Expanded(child: Divider()),
                      ],
                    ),
                  ),
                ...SocialSignInMethod.values
                    .map(
                      (method) => !providers.contains(method.name)
                          ? SocialSignInButton(method: method)
                          : const SizedBox(),
                    )
                    .toList(),
              ],
            );
          },
          error: (_, __) => const SizedBox(),
          loading: () => const SizedBox(),
        );
  }
}

/// 連携済みのソーシャルアカウント一覧を表示するウィジェット。
class ConnectedSocialAccountsWidget extends HookConsumerWidget {
  const ConnectedSocialAccountsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(accountProvider).when(
          data: (account) {
            if (account == null) {
              return const SizedBox();
            }
            final providers = account.providers;
            return Column(
              children: SocialSignInMethod.values
                  .map(
                    (method) => providers.contains(method.name)
                        ? [method.connectedSocialAccountWidget, const Gap(8)]
                        : [const SizedBox()],
                  )
                  .expand((element) => element)
                  .toList(),
            );
          },
          error: (_, __) => const SizedBox(),
          loading: () => const SizedBox(),
        );
  }
}
