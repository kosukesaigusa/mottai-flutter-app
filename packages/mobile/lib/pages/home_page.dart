import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/firebase_messaging.dart';
import '../utils/scaffold_messenger.dart';
import '../utils/utils.dart';
import 'second_page.dart';

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
      appBar: AppBar(title: const Text('ホーム')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('HomePage'),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed<void>(
                context,
                SecondPage.location,
                arguments: '2 番目のページ',
              ),
              child: const Text('Go to SecondPage'),
            ),
            const Gap(16),
            ElevatedButton.icon(
              onPressed: () async {
                final fcmToken = await ref.read(getFcmTokenProvider)();
                if (fcmToken == null) {
                  return;
                }
                await db.collection('testNotificationRequests').doc(uuid).set(<String, dynamic>{
                  'token': fcmToken,
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
}
