import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SocialLinkButtons extends ConsumerWidget {
  const SocialLinkButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Image.asset('assets/login_icon/google_icon.png'),
            ),
            const SizedBox(width: 10),
            const Text('Google'),
            // TODO google連携済みかどうかで出し分けられるようにする
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    '連携済',
                    style: TextStyle(color: Theme.of(context).shadowColor),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: FaIcon(
                  FontAwesomeIcons.apple,
                ),
              ),
              const SizedBox(width: 10),
              const Text('Apple'),
              // TODO apple連携済みかどうかで出し分けられるようにする
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      '未連携',
                      style: TextStyle(color: Theme.of(context).shadowColor),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
