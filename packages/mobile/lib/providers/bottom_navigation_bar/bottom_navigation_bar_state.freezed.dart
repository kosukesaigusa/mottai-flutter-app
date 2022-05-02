// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bottom_navigation_bar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BottomNavigationBarState {
  BottomTab get currentBottomTab => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BottomNavigationBarStateCopyWith<BottomNavigationBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottomNavigationBarStateCopyWith<$Res> {
  factory $BottomNavigationBarStateCopyWith(BottomNavigationBarState value,
          $Res Function(BottomNavigationBarState) then) =
      _$BottomNavigationBarStateCopyWithImpl<$Res>;
  $Res call({BottomTab currentBottomTab});
}

/// @nodoc
class _$BottomNavigationBarStateCopyWithImpl<$Res>
    implements $BottomNavigationBarStateCopyWith<$Res> {
  _$BottomNavigationBarStateCopyWithImpl(this._value, this._then);

  final BottomNavigationBarState _value;
  // ignore: unused_field
  final $Res Function(BottomNavigationBarState) _then;

  @override
  $Res call({
    Object? currentBottomTab = freezed,
  }) {
    return _then(_value.copyWith(
      currentBottomTab: currentBottomTab == freezed
          ? _value.currentBottomTab
          : currentBottomTab // ignore: cast_nullable_to_non_nullable
              as BottomTab,
    ));
  }
}

/// @nodoc
abstract class _$TabStateCopyWith<$Res>
    implements $BottomNavigationBarStateCopyWith<$Res> {
  factory _$TabStateCopyWith(_TabState value, $Res Function(_TabState) then) =
      __$TabStateCopyWithImpl<$Res>;
  @override
  $Res call({BottomTab currentBottomTab});
}

/// @nodoc
class __$TabStateCopyWithImpl<$Res>
    extends _$BottomNavigationBarStateCopyWithImpl<$Res>
    implements _$TabStateCopyWith<$Res> {
  __$TabStateCopyWithImpl(_TabState _value, $Res Function(_TabState) _then)
      : super(_value, (v) => _then(v as _TabState));

  @override
  _TabState get _value => super._value as _TabState;

  @override
  $Res call({
    Object? currentBottomTab = freezed,
  }) {
    return _then(_TabState(
      currentBottomTab: currentBottomTab == freezed
          ? _value.currentBottomTab
          : currentBottomTab // ignore: cast_nullable_to_non_nullable
              as BottomTab,
    ));
  }
}

/// @nodoc

class _$_TabState implements _TabState {
  _$_TabState({required this.currentBottomTab});

  @override
  final BottomTab currentBottomTab;

  @override
  String toString() {
    return 'BottomNavigationBarState(currentBottomTab: $currentBottomTab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TabState &&
            const DeepCollectionEquality()
                .equals(other.currentBottomTab, currentBottomTab));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(currentBottomTab));

  @JsonKey(ignore: true)
  @override
  _$TabStateCopyWith<_TabState> get copyWith =>
      __$TabStateCopyWithImpl<_TabState>(this, _$identity);
}

abstract class _TabState implements BottomNavigationBarState {
  factory _TabState({required final BottomTab currentBottomTab}) = _$_TabState;

  @override
  BottomTab get currentBottomTab => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TabStateCopyWith<_TabState> get copyWith =>
      throw _privateConstructorUsedError;
}
