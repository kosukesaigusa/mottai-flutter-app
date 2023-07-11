import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../firestore_documents/host_location.dart';

const geoConverter = GeoConverter();

class GeoConverter implements JsonConverter<Geo, Map<String, dynamic>> {
  const GeoConverter();

  @override
  Geo fromJson(Map<String, dynamic> json) {
    final geohash = json['geohash'] as String;
    final geopoint = json['geopoint'] as GeoPoint;
    return Geo(geohash: geohash, geopoint: geopoint);
  }

  @override
  Map<String, dynamic> toJson(Geo geo) {
    return {
      'geohash': geo.geohash,
      'geopoint': geo.geopoint,
    };
  }
}
