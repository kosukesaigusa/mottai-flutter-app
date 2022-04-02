// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Dart Define で定義する環境変数のキー名
// enum EnvironmentVariable {
//   FLAVOR,
//   LINE_CHANNEL_ID,
// }

/// ソーシャルログインの種類
enum SocialSignInMethod {
  Google,
  Apple,
  LINE,
}

/// ソーシャルログインごとのボタン・アイコンウィジェットの Extension
extension SocialSignInMethodExtension on SocialSignInMethod {
  Widget get buttonIcon {
    switch (this) {
      case SocialSignInMethod.Google:
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage(
                'assets/logos/google_light.png',
                package: 'flutter_signin_button',
              ),
              height: 36,
            ),
          ),
        );
      case SocialSignInMethod.Apple:
        return const Icon(
          FontAwesomeIcons.apple,
          size: 20,
          color: Colors.black,
        );
      case SocialSignInMethod.LINE:
        return const Icon(
          FontAwesomeIcons.line,
          size: 20,
          color: Color(0xff00ba52),
        );
    }
  }
}

/// メッセージの送信者（自分か相手か）
enum SenderType { myself, partner }
