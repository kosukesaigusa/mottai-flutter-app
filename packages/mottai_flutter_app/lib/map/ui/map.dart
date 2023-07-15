import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const path = '/map';
  static const name = 'MapPage';
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マップ')),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(35.681236, 139.767125),
        ),
      ),
    );
  }
}
