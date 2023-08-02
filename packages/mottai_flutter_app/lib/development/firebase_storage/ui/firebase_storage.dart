import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FirebaseStorageSamplePage extends ConsumerStatefulWidget {
  const FirebaseStorageSamplePage({super.key});

  @override
  ConsumerState<FirebaseStorageSamplePage> createState() =>
      _FirebaseStorageSampleState();
}

class _FirebaseStorageSampleState
    extends ConsumerState<FirebaseStorageSamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirebaseStorageを使用するサンプル画面'),
      ),
      body: const Text('sample'),
    );
  }
}
