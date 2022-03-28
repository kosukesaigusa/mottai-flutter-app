import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaygroundPage extends HookConsumerWidget {
  const PlaygroundPage({Key? key}) : super(key: key);

  static const path = '/playground/';
  static const name = 'PlaygroundPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox();
  }
}
