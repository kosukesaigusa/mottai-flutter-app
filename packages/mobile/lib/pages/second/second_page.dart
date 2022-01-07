import 'package:flutter/material.dart';
import 'package:mottai_flutter_app/route/utils.dart';

class SecondPage extends StatefulWidget {
  const SecondPage._({
    Key? key,
    required this.title,
  }) : super(key: key);

  SecondPage.withArgs({
    Key? key,
    required RouteArgs args,
  }) : this._(key: key, title: args['title'] as String);

  static const path = '/second/';
  static const name = 'SecondPage';
  final String title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
