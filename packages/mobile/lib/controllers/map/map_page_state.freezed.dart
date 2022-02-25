// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'map_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$MapPageStateTearOff {
  const _$MapPageStateTearOff();

  _MapPageState call(
      {bool loading = true,
      GeoFirePoint? center,
      List<HostLocation> locations = const <HostLocation>[],
      List<GeoPoint> locations2 = const <GeoPoint>[]}) {
    return _MapPageState(
      loading: loading,
      center: center,
      locations: locations,
      locations2: locations2,
    );
  }
}

/// @nodoc
const $MapPageState = _$MapPageStateTearOff();

/// @nodoc
mixin _$MapPageState {
  bool get loading => throw _privateConstructorUsedError;
  GeoFirePoint? get center => throw _privateConstructorUsedError;
  List<HostLocation> get locations => throw _privateConstructorUsedError;
  List<GeoPoint> get locations2 => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapPageStateCopyWith<MapPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapPageStateCopyWith<$Res> {
  factory $MapPageStateCopyWith(
          MapPageState value, $Res Function(MapPageState) then) =
      _$MapPageStateCopyWithImpl<$Res>;
  $Res call(
      {bool loading,
      GeoFirePoint? center,
      List<HostLocation> locations,
      List<GeoPoint> locations2});
}

/// @nodoc
class _$MapPageStateCopyWithImpl<$Res> implements $MapPageStateCopyWith<$Res> {
  _$MapPageStateCopyWithImpl(this._value, this._then);

  final MapPageState _value;
  // ignore: unused_field
  final $Res Function(MapPageState) _then;

  @override
  $Res call({
    Object? loading = freezed,
    Object? center = freezed,
    Object? locations = freezed,
    Object? locations2 = freezed,
  }) {
    return _then(_value.copyWith(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      center: center == freezed
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as GeoFirePoint?,
      locations: locations == freezed
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<HostLocation>,
      locations2: locations2 == freezed
          ? _value.locations2
          : locations2 // ignore: cast_nullable_to_non_nullable
              as List<GeoPoint>,
    ));
  }
}

/// @nodoc
abstract class _$MapPageStateCopyWith<$Res>
    implements $MapPageStateCopyWith<$Res> {
  factory _$MapPageStateCopyWith(
          _MapPageState value, $Res Function(_MapPageState) then) =
      __$MapPageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool loading,
      GeoFirePoint? center,
      List<HostLocation> locations,
      List<GeoPoint> locations2});
}

/// @nodoc
class __$MapPageStateCopyWithImpl<$Res> extends _$MapPageStateCopyWithImpl<$Res>
    implements _$MapPageStateCopyWith<$Res> {
  __$MapPageStateCopyWithImpl(
      _MapPageState _value, $Res Function(_MapPageState) _then)
      : super(_value, (v) => _then(v as _MapPageState));

  @override
  _MapPageState get _value => super._value as _MapPageState;

  @override
  $Res call({
    Object? loading = freezed,
    Object? center = freezed,
    Object? locations = freezed,
    Object? locations2 = freezed,
  }) {
    return _then(_MapPageState(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      center: center == freezed
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as GeoFirePoint?,
      locations: locations == freezed
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<HostLocation>,
      locations2: locations2 == freezed
          ? _value.locations2
          : locations2 // ignore: cast_nullable_to_non_nullable
              as List<GeoPoint>,
    ));
  }
}

/// @nodoc

class _$_MapPageState implements _MapPageState {
  const _$_MapPageState(
      {this.loading = true,
      this.center,
      this.locations = const <HostLocation>[],
      this.locations2 = const <GeoPoint>[]});

  @JsonKey()
  @override
  final bool loading;
  @override
  final GeoFirePoint? center;
  @JsonKey()
  @override
  final List<HostLocation> locations;
  @JsonKey()
  @override
  final List<GeoPoint> locations2;

  @override
  String toString() {
    return 'MapPageState(loading: $loading, center: $center, locations: $locations, locations2: $locations2)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MapPageState &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            const DeepCollectionEquality().equals(other.center, center) &&
            const DeepCollectionEquality().equals(other.locations, locations) &&
            const DeepCollectionEquality()
                .equals(other.locations2, locations2));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(loading),
      const DeepCollectionEquality().hash(center),
      const DeepCollectionEquality().hash(locations),
      const DeepCollectionEquality().hash(locations2));

  @JsonKey(ignore: true)
  @override
  _$MapPageStateCopyWith<_MapPageState> get copyWith =>
      __$MapPageStateCopyWithImpl<_MapPageState>(this, _$identity);
}

abstract class _MapPageState implements MapPageState {
  const factory _MapPageState(
      {bool loading,
      GeoFirePoint? center,
      List<HostLocation> locations,
      List<GeoPoint> locations2}) = _$_MapPageState;

  @override
  bool get loading;
  @override
  GeoFirePoint? get center;
  @override
  List<HostLocation> get locations;
  @override
  List<GeoPoint> get locations2;
  @override
  @JsonKey(ignore: true)
  _$MapPageStateCopyWith<_MapPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
