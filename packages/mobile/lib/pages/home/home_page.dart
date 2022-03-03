import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:mottai_flutter_app/pages/second/second_page.dart';
import 'package:mottai_flutter_app/route/utils.dart';
import 'package:mottai_flutter_app/theme/theme.dart';

import '../../utils/utils.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  static const path = '/home/';
  static const name = 'HomePage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      drawer: _buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('HomePage'),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed<void>(
                  context,
                  SecondPage.path,
                  arguments: RouteArguments(<String, dynamic>{'title': '2 番目のページ'}),
                );
              },
              child: const Text('Go to SecondPage'),
            ),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: () async {
                await db.collection('testNotificationRequests').doc(uuid).set(<String, dynamic>{
                  'token': await FirebaseMessaging.instance.getToken(),
                });
                ref.read(scaffoldMessengerController).showSnackBar(
                      'テスト通知をリクエストしました。まもなく通知が送られます。',
                    );
              },
              icon: const Icon(Icons.notifications),
              label: const Text('テスト通知を受け取る'),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrawerHeader(context),
          _buildFcmTokenDrawerItem(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('いちさんマップ（仮称）開発版', style: grey12),
          const Gap(8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFcmTokenDrawerItem(BuildContext context) {
    return ListTile(
      title: const Text('FCM トークンの確認'),
      onTap: () async {
        final token = await FirebaseMessaging.instance.getToken();
        print('*** FCM token ***************');
        print(token);
        print('*****************************');
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
}
