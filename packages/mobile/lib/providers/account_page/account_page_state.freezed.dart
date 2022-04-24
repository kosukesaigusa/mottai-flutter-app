// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountPageStateTearOff {
  const _$AccountPageStateTearOff();

  _AccountPageState call({bool loading = true}) {
    return _AccountPageState(
      loading: loading,
    );
  }
}

/// @nodoc
const $AccountPageState = _$AccountPageStateTearOff();

/// @nodoc
mixin _$AccountPageState {
  bool get loading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountPageStateCopyWith<AccountPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountPageStateCopyWith<$Res> {
  factory $AccountPageStateCopyWith(
          AccountPageState value, $Res Function(AccountPageState) then) =
      _$AccountPageStateCopyWithImpl<$Res>;
  $Res call({bool loading});
}

/// @nodoc
class _$AccountPageStateCopyWithImpl<$Res>
    implements $AccountPageStateCopyWith<$Res> {
  _$AccountPageStateCopyWithImpl(this._value, this._then);

  final AccountPageState _value;
  // ignore: unused_field
  final $Res Function(AccountPageState) _then;

  @override
  $Res call({
    Object? loading = freezed,
  }) {
    return _then(_value.copyWith(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$AccountPageStateCopyWith<$Res>
    implements $AccountPageStateCopyWith<$Res> {
  factory _$AccountPageStateCopyWith(
          _AccountPageState value, $Res Function(_AccountPageState) then) =
      __$AccountPageStateCopyWithImpl<$Res>;
  @override
  $Res call({bool loading});
}

/// @nodoc
class __$AccountPageStateCopyWithImpl<$Res>
    extends _$AccountPageStateCopyWithImpl<$Res>
    implements _$AccountPageStateCopyWith<$Res> {
  __$AccountPageStateCopyWithImpl(
      _AccountPageState _value, $Res Function(_AccountPageState) _then)
      : super(_value, (v) => _then(v as _AccountPageState));

  @override
  _AccountPageState get _value => super._value as _AccountPageState;

  @override
  $Res call({
    Object? loading = freezed,
  }) {
    return _then(_AccountPageState(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AccountPageState implements _AccountPageState {
  const _$_AccountPageState({this.loading = true});

  @JsonKey()
  @override
  final bool loading;

  @override
  String toString() {
    return 'AccountPageState(loading: $loading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountPageState &&
            const DeepCollectionEquality().equals(other.loading, loading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(loading));

  @JsonKey(ignore: true)
  @override
  _$AccountPageStateCopyWith<_AccountPageState> get copyWith =>
      __$AccountPageStateCopyWithImpl<_AccountPageState>(this, _$identity);
}

abstract class _AccountPageState implements AccountPageState {
  const factory _AccountPageState({bool loading}) = _$_AccountPageState;

  @override
  bool get loading;
  @override
  @JsonKey(ignore: true)
  _$AccountPageStateCopyWith<_AccountPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
