import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/account/account.dart';
import '../utils/enums.dart';

class SocialSignInButton extends HookConsumerWidget {
  const SocialSignInButton({super.key, required this.method});

  final SocialSignInMethod method;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      key: ValueKey(method.name),
      height: 36,
      elevation: 2,
      padding: EdgeInsets.zero,
      color: const Color(0xFFFFFFFF),
      splashColor: Colors.white30,
      highlightColor: Colors.white30,
      onPressed: () async {
        await ref.read(signInWithSocialAccountProvider)(method);
      },
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 220,
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: _innerPadding(ref),
                child: method.buttonIcon,
              ),
              Text(
                'Sign in with ${method.name}',
                style: const TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.54),
                  fontSize: 14,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// サインイン方法ごとのボタン押下時の処理 innerPadding
  EdgeInsets _innerPadding(WidgetRef ref) {
    if (method == SocialSignInMethod.Google) {
      return const EdgeInsets.only(left: 5);
    } else {
      return const EdgeInsets.only(left: 13, right: 18);
    }
  }
}
