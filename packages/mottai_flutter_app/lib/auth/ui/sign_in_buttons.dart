import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'auth_controller.dart';
import '../auth.dart';


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
            // Google
            SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.google,
                text: 'Sign up with Google',
                onPressed: () async => ref
                      .read(authControllerProvider)
                      .signInOauth(Authenticator.google),
              ),
            ),
            // Apple
            SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.apple,
                text: 'Sign up with Apple',
                onPressed: () async => ref
                              .read(authControllerProvider)
                              .signInOauth(Authenticator.apple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}