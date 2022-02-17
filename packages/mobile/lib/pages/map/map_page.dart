import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  static const path = '/map/';
  static const name = 'MapPage';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('MapPage')),
    );
  }
}
