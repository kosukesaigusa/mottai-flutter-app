import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host_location.flutterfire_gen.dart';

@FirestoreDocument(path: 'hostLocations', documentName: 'hostLocation')
class HostLocation {
  const HostLocation({
    required this.hostId,
    required this.address,
    required this.geo,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;

  @ReadDefault('')
  final String address;

  @_geoConverter
  final Geo geo;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @sealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  final SealedTimestamp createdAt;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @alwaysUseServerTimestampSealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  @UpdateDefault(ServerTimestamp())
  final SealedTimestamp updatedAt;
}

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
