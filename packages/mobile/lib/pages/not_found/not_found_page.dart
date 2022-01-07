import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);
  static const path = '/not-found/';
  static const name = 'NotFoundPage';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ページが見つかりませんでした。'),
      ),
    );
  }
}
