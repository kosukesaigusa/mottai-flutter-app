import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../hooks/package_info_state.dart';
import '../../services/firebase_messaging_service.dart';
import '../../services/scaffold_messenger_service.dart';
import '../../theme/theme.dart';
import '../../utils/restart_app.dart';
import '../../utils/utils.dart';
import '../playgrounds/playground_page.dart';
import '../second/second_page.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  static const path = '/home';
  static const name = 'HomePage';
  static const location = path;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: _buildDrawer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('HomePage'),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed<void>(
                  context,
                  SecondPage.location,
                  arguments: '2 番目のページ',
                );
              },
              child: const Text('Go to SecondPage'),
            ),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: () async {
                await db.collection('testNotificationRequests').doc(uuid).set(<String, dynamic>{
                  'token': ref.read(fcmServiceProvider).getToken,
                });
                ref
                    .read(scaffoldMessengerServiceProvider)
                    .showSnackBar('テスト通知をリクエストしました。まもなく通知が送られます。');
              },
              icon: const Icon(Icons.notifications),
              label: const Text('テスト通知を受け取る'),
            ),
          ],
        ),
      ),
    );
  }

  /// ドロワー全体
  Drawer get _buildDrawer {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrawerHeader,
          _buildFcmTokenDrawerItem,
          _buildPlaygroundMenuDrawerItem,
          _buildSignOutDrawerItem,
        ],
      ),
    );
  }

  /// ドロワーヘッダー
  Widget get _buildDrawerHeader {
    final packageInfoState = usePackageInfoState();
    final packageInfo = packageInfoState.packageInfo;
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            packageInfo == null
                ? ''
                : '${packageInfo.appName}: '
                    '${packageInfo.version} (${packageInfo.buildNumber})',
            style: grey10,
          ),
        ],
      ),
    );
  }

  /// FCM トークンの確認アイテム
  Widget get _buildFcmTokenDrawerItem {
    return ListTile(
      title: const Text('FCM トークンの確認'),
      onTap: () async {
        final token = await ref.read(fcmServiceProvider).getToken;
        debugPrint('*** FCM token ***************');
        debugPrint(token);
        debugPrint('*****************************');
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('FCM トークン'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('この端末の FCM トークンは次の文字列です。', style: grey12),
                  const Gap(8),
                  SelectableText(token ?? 'トークンの取得に失敗しました。'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  ),
                  onPressed: () => Navigator.pop<void>(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// プレイグラウンドへ遷移するためのアイテム
  Widget get _buildPlaygroundMenuDrawerItem {
    return ListTile(
      title: const Text('プレイグランド'),
      onTap: () async {
        await Navigator.pushNamed<void>(context, PlaygroundPage.location);
      },
    );
  }

  /// サインアウトボタン
  Widget get _buildSignOutDrawerItem {
    return ListTile(
      title: const Text('サインアウト'),
      onTap: () async {
        await auth.signOut();
        await ref.read(restartAppProvider)();
      },
    );
  }
}
