import 'package:flutter/material.dart';

import '../../utils/enums.dart';

class SocialSignInButton<T> extends StatelessWidget {
  const SocialSignInButton({
    required this.method,
    required this.onPressed,
    this.innerPadding,
  });

  final SocialSignInMethod method;
  final Future<T> Function() onPressed;
  final EdgeInsets? innerPadding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: ValueKey(method.name),
      height: 36,
      elevation: 2,
      padding: const EdgeInsets.all(0),
      color: const Color(0xFFFFFFFF),
      splashColor: Colors.white30,
      highlightColor: Colors.white30,
      onPressed: onPressed,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 220,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: innerPadding ??
                    const EdgeInsets.symmetric(
                      horizontal: 13,
                    ),
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
}
