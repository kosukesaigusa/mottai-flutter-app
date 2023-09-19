import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../force_update/force_update.dart';
import '../../../scaffold_messenger_controller.dart';

@RoutePage()
class ForceUpdateSamplePage extends ConsumerWidget {
  const ForceUpdateSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/forceUpdateSample';

  /// [ForceUpdateSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フォースアップデート情報'),
      ),
      body: ref.watch(forceUpdateStreamProvider).when(
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
                            ref.watch(isForceUpdateRequiredProvider).toString(),
                          ),
                          subtitle: const Text('アップデートするかどうか'),
                        ),
                        // if (ref.watch(isForceUpdateProvider))
                        ElevatedButton(
                          onPressed: () async {
                            await ref
                                .read(appScaffoldMessengerControllerProvider)
                                .showDialogByBuilder<void>(
                                  builder: (_) => const ForceUpdateDialog(),
                                  barrierDismissible: false,
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

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog();

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
