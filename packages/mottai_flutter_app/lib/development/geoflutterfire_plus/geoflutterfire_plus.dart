import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

/// geoflutterfire_plus パッケージの動作確認用 Widget.
class GeoflutterfirePlusSample extends StatelessWidget {
  const GeoflutterfirePlusSample({super.key});

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
              final locationCollectionRef =
                  FirebaseFirestore.instance.collection('locations');
              const center = GeoFirePoint(GeoPoint(35.681236, 139.767125));
              final result = await GeoCollectionReference(locationCollectionRef)
                  .fetchWithin(
                center: center,
                radiusInKm: 6,
                field: 'geo',
                strictMode: true,
                geopointFrom: (data) => (data['geo']
                    as Map<String, dynamic>)['geopoint'] as GeoPoint,
              );
              debugPrint(result.toString());
            },
          ),
        ],
      ),
    );
  }
}
