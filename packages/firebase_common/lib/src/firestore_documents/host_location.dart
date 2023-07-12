import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

import '../json_converters/geo.dart';

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

  final String address;

  @geoConverter
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
