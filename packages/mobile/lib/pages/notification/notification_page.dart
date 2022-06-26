import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationPage extends HookConsumerWidget {
  const NotificationPage({super.key});

  static const path = '/notification';
  static const name = 'NotificationPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('NotificationPage'),
            Gap(8),
            Text('現在のタブをタップすると元の画面に戻れます。'),
          ],
        ),
      ),
    );
  }
}
