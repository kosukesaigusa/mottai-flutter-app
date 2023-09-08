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
    this.initialMarker,
  }) : _initialCameraPosition = initialCameraPosition!;

  final CameraPosition _initialCameraPosition;
  final Marker? initialMarker;

  @override
  HostLocationSelectDialogState createState() =>
      HostLocationSelectDialogState();
}

/// 位置情報選択ダイアログ
class HostLocationSelectDialogState
    extends ConsumerState<HostLocationSelectDialog> {
  late Marker _selectedMarker;

  @override
  void initState() {
    super.initState();
    if (widget.initialMarker != null) {
      _selectedMarker = widget.initialMarker!;
    } else {
      _selectedMarker = const Marker(markerId: MarkerId('0,0'));
    }
  }

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
                    markers: {_selectedMarker},
                    onTap: (position) {
                      setState(() {
                        _selectedMarker = Marker(
                          markerId: MarkerId(
                            '(${position.latitude}, ${position.longitude})',
                          ),
                          position:
                              LatLng(position.latitude, position.longitude),
                        );
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final geoPoint = GeoPoint(
                    _selectedMarker.position.latitude,
                    _selectedMarker.position.longitude,
                  );
                  final geoFirePoint = GeoFirePoint(geoPoint);
                  final geo = Geo(
                    geohash: geoFirePoint.geohash,
                    geopoint: geoPoint,
                  );

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => _ConfirmDialog(geo: geo),
                  );

                  if (confirm != null && confirm) {
                    if (context.mounted) {
                      Navigator.pop(context, geo);
                    }
                  }
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

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.geo,
  });

  final Geo geo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('位置を選択しました'),
      content: Text(
        '・緯度： ${geo.geopoint.latitude}\n'
        '・緯度： ${geo.geopoint.longitude}\n'
        'の地点を選択しました。\n'
        '\n'
        'マップ上のピンの位置が正しいことを確認してください。\n',
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
