// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HostLocation _$$_HostLocationFromJson(Map<String, dynamic> json) =>
    _$_HostLocation(
      hostLocationId: json['hostLocationId'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : unionTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const UnionTimestamp.serverTimestamp()
          : alwaysUseServerTimestampUnionTimestampConverter
              .fromJson(json['updatedAt'] as Object),
      title: json['title'] as String? ?? '',
      hostId: json['hostId'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageURL: json['imageURL'] as String? ?? '',
      geo: json['geo'] == null
          ? Geo.defaultValue
          : const GeoConverter().fromJson(json['geo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_HostLocationToJson(_$_HostLocation instance) =>
    <String, dynamic>{
      'hostLocationId': instance.hostLocationId,
      'createdAt': unionTimestampConverter.toJson(instance.createdAt),
      'updatedAt': alwaysUseServerTimestampUnionTimestampConverter
          .toJson(instance.updatedAt),
      'title': instance.title,
      'hostId': instance.hostId,
      'address': instance.address,
      'description': instance.description,
      'imageURL': instance.imageURL,
      'geo': const GeoConverter().toJson(instance.geo),
    };

_$_Geo _$$_GeoFromJson(Map<String, dynamic> json) => _$_Geo(
      geohash: json['geohash'] as String? ?? '',
      geopoint: json['geopoint'] == null
          ? const GeoPoint(35.6812, 139.7671)
          : const GeoPointConverter().fromJson(json['geopoint'] as GeoPoint),
    );

Map<String, dynamic> _$$_GeoToJson(_$_Geo instance) => <String, dynamic>{
      'geohash': instance.geohash,
      'geopoint': const GeoPointConverter().toJson(instance.geopoint),
    };
