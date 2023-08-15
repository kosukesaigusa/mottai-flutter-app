import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
        children: const [
          Gap(8),
        ],
      ),
    );
  }
}
