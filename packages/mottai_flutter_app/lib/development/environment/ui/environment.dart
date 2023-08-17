import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../environment.dart';

@RoutePage()
class EnvironmentPage extends ConsumerWidget {
  const EnvironmentPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/environment';

  /// [EnvironmentPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavorName = ref.watch(flavorNameProvider);
    final appName = ref.watch(appNameProvider);
    final appIdSuffix = ref.watch(appIdSuffixProvider);
    final lineChannelId = ref.watch(lineChannelIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('flavor環境情報'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('flavorName'),
            Text(flavorName),
            const Text('appName'),
            Text(appName),
            const Text('appIdSuffix'),
            Text(appIdSuffix),
            const Text('lineChannelId'),
            Text(lineChannelId),
          ],
        ),
      ),
    );
  }
}
