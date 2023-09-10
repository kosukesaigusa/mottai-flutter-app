import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'auth_controller.dart';
import 'button_builder.dart' as login_button;

/// サインアウト時に表示する UI.
class SignedOut extends StatelessWidget {
  const SignedOut({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('機能を使用するには、サインインが必要です。'),
          Text('下記のいずれかの方法でサインインしてください。'),
          Gap(24),
          SignInButtons(),
        ],
      ),
    );
  }
}

/// サインイン方法のボタン一覧を表示する UI.
class SignInButtons extends ConsumerWidget {
  const SignInButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 48,
          child: SignInButton(
            Buttons.google,
            text: 'Google でサインイン',
            onPressed: () async =>
                ref.read(authControllerProvider).signIn(SignInMethod.google),
          ),
        ),
        // TODO: Apple の審査中のみ表示するようにする
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          const Gap(32),
          SizedBox(
            height: 48,
            child: SignInButton(
              Buttons.appleDark,
              text: 'Apple でサインイン',
              onPressed: () async =>
                  ref.read(authControllerProvider).signIn(SignInMethod.apple),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
        const Gap(32),
        SizedBox(
          height: 48,
          child: login_button.SignInButtonBuilder(
            text: 'LINE でサインイン',
            onPressed: () async =>
                ref.read(authControllerProvider).signIn(SignInMethod.line),
            backgroundColor: const Color(0xff06C755),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            image: Image.asset(
              'assets/login_icon/line_icon.png',
              height: 36,
            ),
            separator: const VerticalDivider(
              width: 1,
              color: Color.fromRGBO(0, 0, 0, 0.08),
            ),
            separatorSpaceRight: 36,
          ),
        ),
      ],
    );
  }
}
