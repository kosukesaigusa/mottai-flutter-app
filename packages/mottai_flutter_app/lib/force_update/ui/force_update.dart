import 'package:flutter/material.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('アプリの更新'),
      content: const Text(
        '最新バージョンのアプリがご利用可能です。下記のボタンを押してダウンロードしてください。',
      ),
      actions: <Widget>[
        if (Theme.of(context).platform == TargetPlatform.iOS)
          ElevatedButton(
            onPressed: () {
              // TODO: AppStore へ飛ばす処理を追加する
            },
            child: const Text('App Store'),
          )
        else if (Theme.of(context).platform == TargetPlatform.android)
          ElevatedButton(
            onPressed: () {
              // TODO: Google Play Store へ飛ばす処理を追加する
            },
            child: const Text('Google Play Store'),
          ),
      ],
    );
  }
}
