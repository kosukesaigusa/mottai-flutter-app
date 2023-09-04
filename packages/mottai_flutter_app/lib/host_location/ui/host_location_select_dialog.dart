import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HostLocationSelectDialog extends ConsumerStatefulWidget {
  HostLocationSelectDialog({
    super.key,
    CameraPosition? initialCameraPosition,
  }) : _initialCameraPosition = initialCameraPosition!;

  final CameraPosition _initialCameraPosition;

  @override
  HostLocationSelectDialogState createState() =>
      HostLocationSelectDialogState();
}

/// 位置情報選択ダイアログ
class HostLocationSelectDialogState
    extends ConsumerState<HostLocationSelectDialog> {
  Marker _selectedMarker = const Marker(
    markerId: MarkerId('(0, 0)'),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: const Text('位置情報を選択')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'マップ上であなたの農園や主な作業場所を長押しして、'
                '登録する位置情報を選択してください。\n'
                '必ずしも正確な位置を指定する必要はありません。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: GoogleMap(
                    initialCameraPosition: widget._initialCameraPosition,
                    markers: {
                      _selectedMarker,
                    },
                    onTap: (position) {
                      setState(() {
                        _selectedMarker = Marker(
                          markerId: MarkerId(
                              '(${position.latitude}, ${position.longitude})'),
                          position:
                              LatLng(position.latitude, position.longitude),
                        );
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final geoPoint = GeoPoint(_selectedMarker.position.latitude,
                      _selectedMarker.position.longitude);
                  final geoFirePoint = GeoFirePoint(geoPoint);
                  final geo = Geo(
                    geohash: geoFirePoint.geohash,
                    geopoint: geoPoint,
                  );
                  Navigator.pop(context, geo);
                },
                child: const Text('位置情報を決定する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
