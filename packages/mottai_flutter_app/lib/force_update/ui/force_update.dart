import 'package:flutter/material.dart';
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
              child: forceUpdateConfig != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            forceUpdateConfig.androidForceUpdate.toString(),
                          ),
                          subtitle: const Text('androidForceUpdate'),
                        ),
                        ListTile(
                          title: Text(
                            forceUpdateConfig.androidLatestVersion,
                          ),
                          subtitle: const Text('androidLatestVersion'),
                        ),
                        ListTile(
                          title: Text(
                            forceUpdateConfig.androidMinRequiredVersion,
                          ),
                          subtitle: const Text('androidMinRequiredVersion'),
                        ),
                        ListTile(
                          title: Text(
                            forceUpdateConfig.iOSForceUpdate.toString(),
                          ),
                          subtitle: const Text('iOSForceUpdate'),
                        ),
                        ListTile(
                          title: Text(
                            forceUpdateConfig.iOSLatestVersion,
                          ),
                          subtitle: const Text('iOSLatestVersion'),
                        ),
                        ListTile(
                          title: Text(
                            forceUpdateConfig.iOSMinRequiredVersion,
                          ),
                          subtitle: const Text('iOSMinRequiredVersion'),
                        ),
                        ListTile(
                          title: Text(
                            ref.watch(isForceUpdateProvider).toString(),
                          ),
                          subtitle: const Text('アップデートするかどうか'),
                        ),
                        // if (ref.watch(isForceUpdateProvider))
                        ElevatedButton(
                          onPressed: () async {
                            await showDialog<Widget>(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => const _ForceUpdateDialog(),
                            );
                          },
                          child: const Text('ダイアログ表示'),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}

class _ForceUpdateDialog extends StatelessWidget {
  const _ForceUpdateDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('最新バージョンを App Store または Google Play Store でダウンロードしてください'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO:アプリAppStoreへ飛ばす処理を追加
          },
          child: const Text('App Store'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO:アプリGoogle Play Storeへ飛ばす処理を追加
          },
          child: const Text('Google Play Store'),
        ),
      ],
    );
  }
}
