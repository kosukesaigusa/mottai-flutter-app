import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host_location.flutterfire_gen.dart';

// NOT: ドキュメント ID は hostId と一致する。
@FirestoreDocument(path: 'hostLocations', documentName: 'hostLocation')
class HostLocation {
  const HostLocation({
    required this.address,
    required this.geo,
    this.createdAt,
    this.updatedAt,
  });

  @ReadDefault('')
  final String address;

  @_geoConverter
//   @TranslateJsonConverterToTypeScript(
//     fromJson: '''
// (json: Record<string, unknown>): Geo {
//   const geohash = json['geohash'] as string
//   const geopoint = json['geopoint'] as GeoPoint
//   return new Geo({ geohash, geopoint })
// }
// ''',
//     toJson: '''
// (geo: Geo): Record<string, unknown> {
//   return {
//     geohash: geo.geohash,
//     geopoint: geo.geopoint
//   }
// }
// ''',
//   )
  final Geo geo;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}

// @TranslateToTypeScript()
class Geo {
  const Geo({
    required this.geohash,
    required this.geopoint,
  });

  final String geohash;

  final GeoPoint geopoint;
}

const _geoConverter = _GeoConverter();

class _GeoConverter implements JsonConverter<Geo, Map<String, dynamic>> {
  const _GeoConverter();

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
