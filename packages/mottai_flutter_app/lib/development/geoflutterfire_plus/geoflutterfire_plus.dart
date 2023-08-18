import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

/// geoflutterfire_plus パッケージの動作確認用 Widget.
class GeoflutterfirePlusSample extends StatelessWidget {
  const GeoflutterfirePlusSample({super.key});

  static const _latitude = 35.681236;

  static const _longitude = 139.767125;

  static final _locationsCollectionReference =
      FirebaseFirestore.instance.collection('sampleLocations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Call fetchWithin method'),
            onTap: () async {
              const center = GeoFirePoint(GeoPoint(_latitude, _longitude));
              final result =
                  await GeoCollectionReference(_locationsCollectionReference)
                      .fetchWithin(
                center: center,
                radiusInKm: 6,
                field: 'geo',
                strictMode: true,
                geopointFrom: (data) => (data['geo']
                    as Map<String, dynamic>)['geopoint'] as GeoPoint,
              );
              // output: 50
              debugPrint(result.length.toString());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (var i = 0; i < 50; i++) {
            final newLatitude = _latitude + i * 0.0001;
            final newLongitude = _longitude + i * 0.0001;
            final newGeoFirePoint =
                GeoFirePoint(GeoPoint(newLatitude, newLongitude));
            _locationsCollectionReference.add(<String, dynamic>{
              'geo': <String, dynamic>{
                'geopoint': newGeoFirePoint.geopoint,
                'geohash': newGeoFirePoint.geohash,
              },
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
