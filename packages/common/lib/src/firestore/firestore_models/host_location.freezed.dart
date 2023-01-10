// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HostLocation _$HostLocationFromJson(Map<String, dynamic> json) {
  return _HostLocation.fromJson(json);
}

/// @nodoc
mixin _$HostLocation {
  String get hostLocationId => throw _privateConstructorUsedError;
  @unionTimestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get updatedAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageURL => throw _privateConstructorUsedError;
  @GeoConverter()
  Geo get geo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HostLocationCopyWith<HostLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostLocationCopyWith<$Res> {
  factory $HostLocationCopyWith(
          HostLocation value, $Res Function(HostLocation) then) =
      _$HostLocationCopyWithImpl<$Res, HostLocation>;
  @useResult
  $Res call(
      {String hostLocationId,
      @unionTimestampConverter UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter UnionTimestamp updatedAt,
      String title,
      String hostId,
      String address,
      String description,
      String imageURL,
      @GeoConverter() Geo geo});

  $UnionTimestampCopyWith<$Res> get createdAt;
  $UnionTimestampCopyWith<$Res> get updatedAt;
  $GeoCopyWith<$Res> get geo;
}

/// @nodoc
class _$HostLocationCopyWithImpl<$Res, $Val extends HostLocation>
    implements $HostLocationCopyWith<$Res> {
  _$HostLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostLocationId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = null,
    Object? hostId = null,
    Object? address = null,
    Object? description = null,
    Object? imageURL = null,
    Object? geo = null,
  }) {
    return _then(_value.copyWith(
      hostLocationId: null == hostLocationId
          ? _value.hostLocationId
          : hostLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: null == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as Geo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get createdAt {
    return $UnionTimestampCopyWith<$Res>(_value.createdAt, (value) {
      return _then(_value.copyWith(createdAt: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UnionTimestampCopyWith<$Res> get updatedAt {
    return $UnionTimestampCopyWith<$Res>(_value.updatedAt, (value) {
      return _then(_value.copyWith(updatedAt: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GeoCopyWith<$Res> get geo {
    return $GeoCopyWith<$Res>(_value.geo, (value) {
      return _then(_value.copyWith(geo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_HostLocationCopyWith<$Res>
    implements $HostLocationCopyWith<$Res> {
  factory _$$_HostLocationCopyWith(
          _$_HostLocation value, $Res Function(_$_HostLocation) then) =
      __$$_HostLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String hostLocationId,
      @unionTimestampConverter UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter UnionTimestamp updatedAt,
      String title,
      String hostId,
      String address,
      String description,
      String imageURL,
      @GeoConverter() Geo geo});

  @override
  $UnionTimestampCopyWith<$Res> get createdAt;
  @override
  $UnionTimestampCopyWith<$Res> get updatedAt;
  @override
  $GeoCopyWith<$Res> get geo;
}

/// @nodoc
class __$$_HostLocationCopyWithImpl<$Res>
    extends _$HostLocationCopyWithImpl<$Res, _$_HostLocation>
    implements _$$_HostLocationCopyWith<$Res> {
  __$$_HostLocationCopyWithImpl(
      _$_HostLocation _value, $Res Function(_$_HostLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostLocationId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = null,
    Object? hostId = null,
    Object? address = null,
    Object? description = null,
    Object? imageURL = null,
    Object? geo = null,
  }) {
    return _then(_$_HostLocation(
      hostLocationId: null == hostLocationId
          ? _value.hostLocationId
          : hostLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: null == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as Geo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_HostLocation implements _HostLocation {
  const _$_HostLocation(
      {this.hostLocationId = '',
      @unionTimestampConverter
          this.createdAt = const UnionTimestamp.serverTimestamp(),
      @alwaysUseServerTimestampUnionTimestampConverter
          this.updatedAt = const UnionTimestamp.serverTimestamp(),
      this.title = '',
      this.hostId = '',
      this.address = '',
      this.description = '',
      this.imageURL = '',
      @GeoConverter()
          this.geo = Geo.defaultValue});

  factory _$_HostLocation.fromJson(Map<String, dynamic> json) =>
      _$$_HostLocationFromJson(json);

  @override
  @JsonKey()
  final String hostLocationId;
  @override
  @JsonKey()
  @unionTimestampConverter
  final UnionTimestamp createdAt;
  @override
  @JsonKey()
  @alwaysUseServerTimestampUnionTimestampConverter
  final UnionTimestamp updatedAt;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String hostId;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String imageURL;
  @override
  @JsonKey()
  @GeoConverter()
  final Geo geo;

  @override
  String toString() {
    return 'HostLocation(hostLocationId: $hostLocationId, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, hostId: $hostId, address: $address, description: $description, imageURL: $imageURL, geo: $geo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HostLocation &&
            (identical(other.hostLocationId, hostLocationId) ||
                other.hostLocationId == hostLocationId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageURL, imageURL) ||
                other.imageURL == imageURL) &&
            (identical(other.geo, geo) || other.geo == geo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hostLocationId, createdAt,
      updatedAt, title, hostId, address, description, imageURL, geo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HostLocationCopyWith<_$_HostLocation> get copyWith =>
      __$$_HostLocationCopyWithImpl<_$_HostLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HostLocationToJson(
      this,
    );
  }
}

abstract class _HostLocation implements HostLocation {
  const factory _HostLocation(
      {final String hostLocationId,
      @unionTimestampConverter
          final UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter
          final UnionTimestamp updatedAt,
      final String title,
      final String hostId,
      final String address,
      final String description,
      final String imageURL,
      @GeoConverter()
          final Geo geo}) = _$_HostLocation;

  factory _HostLocation.fromJson(Map<String, dynamic> json) =
      _$_HostLocation.fromJson;

  @override
  String get hostLocationId;
  @override
  @unionTimestampConverter
  UnionTimestamp get createdAt;
  @override
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get updatedAt;
  @override
  String get title;
  @override
  String get hostId;
  @override
  String get address;
  @override
  String get description;
  @override
  String get imageURL;
  @override
  @GeoConverter()
  Geo get geo;
  @override
  @JsonKey(ignore: true)
  _$$_HostLocationCopyWith<_$_HostLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

Geo _$GeoFromJson(Map<String, dynamic> json) {
  return _Geo.fromJson(json);
}

/// @nodoc
mixin _$Geo {
  String get geohash => throw _privateConstructorUsedError;
  @GeoPointConverter()
  GeoPoint get geopoint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeoCopyWith<Geo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoCopyWith<$Res> {
  factory $GeoCopyWith(Geo value, $Res Function(Geo) then) =
      _$GeoCopyWithImpl<$Res, Geo>;
  @useResult
  $Res call({String geohash, @GeoPointConverter() GeoPoint geopoint});
}

/// @nodoc
class _$GeoCopyWithImpl<$Res, $Val extends Geo> implements $GeoCopyWith<$Res> {
  _$GeoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geohash = null,
    Object? geopoint = null,
  }) {
    return _then(_value.copyWith(
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as String,
      geopoint: null == geopoint
          ? _value.geopoint
          : geopoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GeoCopyWith<$Res> implements $GeoCopyWith<$Res> {
  factory _$$_GeoCopyWith(_$_Geo value, $Res Function(_$_Geo) then) =
      __$$_GeoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String geohash, @GeoPointConverter() GeoPoint geopoint});
}

/// @nodoc
class __$$_GeoCopyWithImpl<$Res> extends _$GeoCopyWithImpl<$Res, _$_Geo>
    implements _$$_GeoCopyWith<$Res> {
  __$$_GeoCopyWithImpl(_$_Geo _value, $Res Function(_$_Geo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geohash = null,
    Object? geopoint = null,
  }) {
    return _then(_$_Geo(
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as String,
      geopoint: null == geopoint
          ? _value.geopoint
          : geopoint // ignore: cast_nullable_to_non_nullable
              as GeoPoint,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Geo implements _Geo {
  const _$_Geo(
      {this.geohash = '',
      @GeoPointConverter() this.geopoint = const GeoPoint(35.6812, 139.7671)});

  factory _$_Geo.fromJson(Map<String, dynamic> json) => _$$_GeoFromJson(json);

  @override
  @JsonKey()
  final String geohash;
  @override
  @JsonKey()
  @GeoPointConverter()
  final GeoPoint geopoint;

  @override
  String toString() {
    return 'Geo(geohash: $geohash, geopoint: $geopoint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Geo &&
            (identical(other.geohash, geohash) || other.geohash == geohash) &&
            (identical(other.geopoint, geopoint) ||
                other.geopoint == geopoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, geohash, geopoint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeoCopyWith<_$_Geo> get copyWith =>
      __$$_GeoCopyWithImpl<_$_Geo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GeoToJson(
      this,
    );
  }
}

abstract class _Geo implements Geo {
  const factory _Geo(
      {final String geohash,
      @GeoPointConverter() final GeoPoint geopoint}) = _$_Geo;

  factory _Geo.fromJson(Map<String, dynamic> json) = _$_Geo.fromJson;

  @override
  String get geohash;
  @override
  @GeoPointConverter()
  GeoPoint get geopoint;
  @override
  @JsonKey(ignore: true)
  _$$_GeoCopyWith<_$_Geo> get copyWith => throw _privateConstructorUsedError;
}
