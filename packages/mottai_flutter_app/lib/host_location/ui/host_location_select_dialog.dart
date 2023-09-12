import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../scaffold_messenger_controller.dart';

/// [GoogleMap] 上にピンをたてて、[HostLocation.geo] を選択するページ。
/// `Navigator.of(context).pop()` の引数で選択した [Geo] を返す。
class HostLocationSelectPage extends ConsumerStatefulWidget {
  HostLocationSelectPage({
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
    extends ConsumerState<HostLocationSelectPage> {
  /// 選択中の [Marker].
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
    return Scaffold(
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
            const Gap(16),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: widget._initialCameraPosition,
                markers: {_selectedMarker},
                onLongPress: (position) {
                  setState(() {
                    _selectedMarker = Marker(
                      markerId: MarkerId(
                        '(${position.latitude}, ${position.longitude})',
                      ),
                      position: LatLng(position.latitude, position.longitude),
                    );
                  });
                  ref.read(appScaffoldMessengerControllerProvider).showSnackBar(
                        '位置を選択しました。\n'
                        // ignore: lines_longer_than_80_chars
                        '緯度: ${position.latitude.toString().substring(0, 6)}, '
                        // ignore: lines_longer_than_80_chars
                        '経度: ${position.longitude.toString().substring(0, 6)}',
                      );
                },
              ),
            ),
            const Gap(32),
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
                  builder: (context) => AlertDialog(
                    title: const Text('位置を選択しました'),
                    content: Text(
                      // ignore: lines_longer_than_80_chars
                      '• 緯度: ${geo.geopoint.latitude.toString().substring(0, 6)}\n'
                      // ignore: lines_longer_than_80_chars
                      '• 緯度: ${geo.geopoint.longitude.toString().substring(0, 6)}\n'
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
                  ),
                );
                if (confirm ?? false) {
                  if (context.mounted) {
                    Navigator.pop(context, geo);
                  }
                }
              },
              child: const Text('位置情報を決定する'),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}
