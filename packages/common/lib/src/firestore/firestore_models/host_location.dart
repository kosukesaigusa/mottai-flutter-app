import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common.dart';
import '../../utils/json_converters/geo_point.dart';

part 'host_location.freezed.dart';
part 'host_location.g.dart';

@freezed
class HostLocation with _$HostLocation {
  const factory HostLocation({
    @Default('') String hostLocationId,
    @unionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp createdAt,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp updatedAt,
    @Default('') String title,
    @Default('') String hostId,
    @Default('') String address,
    @Default('') String description,
    @Default('') String imageURL,
    @Default(Geo.defaultValue) @GeoConverter() Geo geo,
  }) = _HostLocation;

  factory HostLocation.fromJson(Map<String, dynamic> json) =>
      _$HostLocationFromJson(json);

  factory HostLocation.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return HostLocation.fromJson(<String, dynamic>{
      ...data,
      'hostLocationId': ds.id,
    });
  }
}

@freezed
class Geo with _$Geo {
  const factory Geo({
    @Default('') String geohash,
    @Default(GeoPoint(35.6812, 139.7671))
    @GeoPointConverter()
        GeoPoint geopoint,
  }) = _Geo;

  factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);

  static const defaultValue = Geo();
}

class GeoConverter implements JsonConverter<Geo, Map<String, dynamic>> {
  const GeoConverter();

  @override
  Geo fromJson(Map<String, dynamic> positionMap) {
    final geohash = (positionMap['geohash'] ?? '') as String;
    final geopoint = positionMap['geopoint'] as GeoPoint;
    return Geo(geohash: geohash, geopoint: geopoint);
  }

  @override
  Map<String, dynamic> toJson(Geo geo) => <String, dynamic>{
        'geohash': geo.geohash,
        'geopoint': geo.geopoint,
      };
}
