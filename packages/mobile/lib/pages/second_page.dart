import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../route/app_router_state.dart';
import '../route/bottom_tabs.dart';
import '../services/navigation.dart';
import '../utils/exceptions/base.dart';
import 'map_page.dart';

final _titleProvider = Provider.autoDispose<String>(
  (ref) {
    final title = ref.read(extractExtraDataProvider)<String>();
    if (title == null) {
      throw const AppException(message: 'タイトルが取得できませんでした。');
    }
    return title;
  },
  dependencies: [
    extractExtraDataProvider,
    appRouterStateProvider,
  ],
);

class SecondPage extends StatefulHookConsumerWidget {
  const SecondPage({super.key});

  static const path = '/second/';
  static const name = 'SecondPage';
  static const location = path;

  @override
  ConsumerState<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends ConsumerState<SecondPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(_titleProvider)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed<void>(context, MapPage.location),
              child: const Text('Go to Map Page'),
            ),
            ElevatedButton(
              onPressed: () =>
                  ref.read(navigationServiceProvider).popUntilFirstRouteAndPushOnSpecifiedTab(
                        bottomTab: bottomTabs[3],
                        location: SecondPage.location,
                        extra: 'タイトル',
                      ),
              child: const Text('Push Second Page on Account Tab'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
