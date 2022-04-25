// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

/// ソーシャルログインの種類
enum SocialSignInMethod {
  Google,
  Apple,
  LINE,
  Twitter,
}

/// ソーシャルログインごとのボタン・アイコンウィジェットの Extension
extension SocialSignInMethodExtension on SocialSignInMethod {
  IconData get iconData {
    switch (this) {
      case SocialSignInMethod.Google:
        return FontAwesomeIcons.google;
      case SocialSignInMethod.Apple:
        return FontAwesomeIcons.apple;
      case SocialSignInMethod.LINE:
        return FontAwesomeIcons.line;
      case SocialSignInMethod.Twitter:
        return FontAwesomeIcons.twitter;
    }
  }

  Color get iconColor {
    switch (this) {
      case SocialSignInMethod.Google:
        return const Color(0xff3369E8);
      case SocialSignInMethod.Apple:
        return Colors.black;
      case SocialSignInMethod.LINE:
        return const Color(0xff00ba52);
      case SocialSignInMethod.Twitter:
        return const Color(0xff1da1f2);
    }
  }

  /// それぞれのソーシャルログインをするボタンのアイコンウィジェット
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
      case SocialSignInMethod.LINE:
      case SocialSignInMethod.Twitter:
        return Icon(iconData, size: 20, color: iconColor);
    }
  }

  /// それぞれのソーシャルログイン連携済みのウィジェト
  Widget get connectedSocialAccountWidget => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(iconData, size: 12, color: iconColor),
          const Gap(8),
          Text(
            '$name 連携済み',
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
          ),
        ],
      );
}

/// メッセージの送信者（自分か相手か）
enum SenderType { myself, partner }
