import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'auth_controller.dart';
import 'button_builder.dart' as login_button;

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
