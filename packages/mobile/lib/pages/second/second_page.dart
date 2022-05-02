import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route/bottom_tabs.dart';
import '../../route/utils.dart';
import '../../services/navigation.dart';
import '../account/account_page.dart';
import '../map/map_page.dart';

class SecondPage extends StatefulHookConsumerWidget {
  const SecondPage._({
    Key? key,
    required this.title,
  }) : super(key: key);

  SecondPage.withArguments({
    Key? key,
    required RouteArguments args,
  }) : this._(key: key, title: args['title'] as String);

  static const path = '/second/';
  static const name = 'SecondPage';
  final String title;

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
        title: Text(widget.title),
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
              onPressed: () async {
                await Navigator.pushNamed<void>(context, MapPage.path);
              },
              child: const Text('Go to Map Page'),
            ),
            ElevatedButton(
              onPressed: () async {
                // AccountPage の上に SecondPage を push する
                await ref.read(navigationServiceProvider).popUntilFirstRouteAndPushOnSpecifiedTab(
                  bottomTab: BottomTab.getByPath(AccountPage.path),
                  path: '/second/',
                  data: <String, dynamic>{'title': 'タイトル'},
                );
              },
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
