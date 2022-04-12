import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'hero/hero_page.dart';
import 'infinite_scroll_page.dart';

class PlaygroundPage extends StatefulHookConsumerWidget {
  const PlaygroundPage({Key? key}) : super(key: key);

  static const path = '/playground/';
  static const name = 'PlaygroundPage';

  @override
  ConsumerState<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends ConsumerState<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed<void>(context, InfiniteScrollPage.path);
              },
              child: const Text('Riverpod 無限スクロールのチャット'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed<void>(context, HeroImagesPage.path);
              },
              child: const Text('ヒーロ画像の画面遷移のサンプル'),
            ),
          ],
        ),
      ),
    );
  }
}
