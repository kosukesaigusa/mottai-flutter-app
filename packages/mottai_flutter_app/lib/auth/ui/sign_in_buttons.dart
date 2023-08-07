import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../auth.dart';
import 'auth_controller.dart';

class GoogleAppleSignin extends ConsumerWidget {
  const GoogleAppleSignin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サインインページ'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.google,
                text: 'Google でサインイン',
                onPressed: () async => ref
                    .read(authControllerProvider)
                    .signIn(SignInMethod.google),
              ),
            ),
            SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.apple,
                text: 'Apple でサインイン',
                onPressed: () async =>
                    ref.read(authControllerProvider).signIn(SignInMethod.apple),
              ),
            ),
            ElevatedButton(
              child: const Text('Line でサインイン'),
              onPressed: () async =>
                  ref.read(authControllerProvider).signIn(SignInMethod.line),
            ),
          ],
        ),
      ),
    );
  }
}
