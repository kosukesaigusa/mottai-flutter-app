import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../force_update.dart';

class ForceUpdatePage extends ConsumerWidget {
  const ForceUpdatePage({super.key});

  static const path = '/forceUpdate';
  static const name = 'ForceUpdatePage';
  static const location = name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フォースアップデート情報'),
      ),
      body: ref.watch(forceUpdateFutureProvider).when(
            data: (forceUpdateConfig) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].androidForceUpdate.toString(),
                    ),
                    subtitle: const Text('androidForceUpdate'),
                  ),
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].androidLatestVersion,
                    ),
                    subtitle: const Text('androidLatestVersion'),
                  ),
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].androidMinRequiredVersion,
                    ),
                    subtitle: const Text('androidMinRequiredVersion'),
                  ),
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].iOSForceUpdate.toString(),
                    ),
                    subtitle: const Text('iOSForceUpdate'),
                  ),
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].iOSLatestVersion,
                    ),
                    subtitle: const Text('iOSLatestVersion'),
                  ),
                  ListTile(
                    title: Text(
                      forceUpdateConfig[0].iOSMinRequiredVersion,
                    ),
                    subtitle: const Text('iOSMinRequiredVersion'),
                  ),
                ],
              ),
            ),
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
