import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class FirebaseMessagingPage extends ConsumerStatefulWidget {
  const FirebaseMessagingPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/firebaseMessagingSample';

  /// [FirebaseMessagingPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<FirebaseMessagingPage> createState() =>
      _FirebaseStorageSampleState();
}

class _FirebaseStorageSampleState extends ConsumerState<FirebaseMessagingPage> {
  String userId = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プッシュ通知のサンプル画面'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'userIdを入力してtestNotificationsコレクションに'
              '適当なドキュメントを追加しそれをトリガーとしてプッシュ通知を送る。'
              'userFcmTokensコレクションから入力したuserIdを持つドキュメントを'
              '取得してプッシュ通知を送っています。プッシュ通知タップ後サンプルサインイン画面に遷移する。',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(hintText: 'userIdを入力してください'),
              onChanged: (input) {
                setState(() {
                  userId = input;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('testNotifications')
                    .add({'createdAt': Timestamp.now(), 'userId': userId});
              },
              child: const Text('Add testNotification document'),
            ),
          ),
        ],
      ),
    );
  }
}
