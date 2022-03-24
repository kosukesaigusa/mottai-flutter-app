// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'room_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RoomPageStateTearOff {
  const _$RoomPageStateTearOff();

  _RoomPageState call({bool loading = true, bool sending = false}) {
    return _RoomPageState(
      loading: loading,
      sending: sending,
    );
  }
}

/// @nodoc
const $RoomPageState = _$RoomPageStateTearOff();

/// @nodoc
mixin _$RoomPageState {
  bool get loading => throw _privateConstructorUsedError;
  bool get sending => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoomPageStateCopyWith<RoomPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomPageStateCopyWith<$Res> {
  factory $RoomPageStateCopyWith(
          RoomPageState value, $Res Function(RoomPageState) then) =
      _$RoomPageStateCopyWithImpl<$Res>;
  $Res call({bool loading, bool sending});
}

/// @nodoc
class _$RoomPageStateCopyWithImpl<$Res>
    implements $RoomPageStateCopyWith<$Res> {
  _$RoomPageStateCopyWithImpl(this._value, this._then);

  final RoomPageState _value;
  // ignore: unused_field
  final $Res Function(RoomPageState) _then;

  @override
  $Res call({
    Object? loading = freezed,
    Object? sending = freezed,
  }) {
    return _then(_value.copyWith(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: sending == freezed
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$RoomPageStateCopyWith<$Res>
    implements $RoomPageStateCopyWith<$Res> {
  factory _$RoomPageStateCopyWith(
          _RoomPageState value, $Res Function(_RoomPageState) then) =
      __$RoomPageStateCopyWithImpl<$Res>;
  @override
  $Res call({bool loading, bool sending});
}

/// @nodoc
class __$RoomPageStateCopyWithImpl<$Res>
    extends _$RoomPageStateCopyWithImpl<$Res>
    implements _$RoomPageStateCopyWith<$Res> {
  __$RoomPageStateCopyWithImpl(
      _RoomPageState _value, $Res Function(_RoomPageState) _then)
      : super(_value, (v) => _then(v as _RoomPageState));

  @override
  _RoomPageState get _value => super._value as _RoomPageState;

  @override
  $Res call({
    Object? loading = freezed,
    Object? sending = freezed,
  }) {
    return _then(_RoomPageState(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: sending == freezed
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RoomPageState implements _RoomPageState {
  const _$_RoomPageState({this.loading = true, this.sending = false});

  @JsonKey()
  @override
  final bool loading;
  @JsonKey()
  @override
  final bool sending;

  @override
  String toString() {
    return 'RoomPageState(loading: $loading, sending: $sending)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoomPageState &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            const DeepCollectionEquality().equals(other.sending, sending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(loading),
      const DeepCollectionEquality().hash(sending));

  @JsonKey(ignore: true)
  @override
  _$RoomPageStateCopyWith<_RoomPageState> get copyWith =>
      __$RoomPageStateCopyWithImpl<_RoomPageState>(this, _$identity);
}

abstract class _RoomPageState implements RoomPageState {
  const factory _RoomPageState({bool loading, bool sending}) = _$_RoomPageState;

  @override
  bool get loading;
  @override
  bool get sending;
  @override
  @JsonKey(ignore: true)
  _$RoomPageStateCopyWith<_RoomPageState> get copyWith =>
      throw _privateConstructorUsedError;
}