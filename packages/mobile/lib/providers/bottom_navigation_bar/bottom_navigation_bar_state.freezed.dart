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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BottomNavigationBarStateTearOff {
  const _$BottomNavigationBarStateTearOff();

  _TabState call(
      {int currentIndex = 0, BottomTabEnum currentTab = BottomTabEnum.home}) {
    return _TabState(
      currentIndex: currentIndex,
      currentTab: currentTab,
    );
  }
}

/// @nodoc
const $BottomNavigationBarState = _$BottomNavigationBarStateTearOff();

/// @nodoc
mixin _$BottomNavigationBarState {
  int get currentIndex => throw _privateConstructorUsedError;
  BottomTabEnum get currentTab => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BottomNavigationBarStateCopyWith<BottomNavigationBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BottomNavigationBarStateCopyWith<$Res> {
  factory $BottomNavigationBarStateCopyWith(BottomNavigationBarState value,
          $Res Function(BottomNavigationBarState) then) =
      _$BottomNavigationBarStateCopyWithImpl<$Res>;
  $Res call({int currentIndex, BottomTabEnum currentTab});
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
    Object? currentIndex = freezed,
    Object? currentTab = freezed,
  }) {
    return _then(_value.copyWith(
      currentIndex: currentIndex == freezed
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentTab: currentTab == freezed
          ? _value.currentTab
          : currentTab // ignore: cast_nullable_to_non_nullable
              as BottomTabEnum,
    ));
  }
}

/// @nodoc
abstract class _$TabStateCopyWith<$Res>
    implements $BottomNavigationBarStateCopyWith<$Res> {
  factory _$TabStateCopyWith(_TabState value, $Res Function(_TabState) then) =
      __$TabStateCopyWithImpl<$Res>;
  @override
  $Res call({int currentIndex, BottomTabEnum currentTab});
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
    Object? currentIndex = freezed,
    Object? currentTab = freezed,
  }) {
    return _then(_TabState(
      currentIndex: currentIndex == freezed
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentTab: currentTab == freezed
          ? _value.currentTab
          : currentTab // ignore: cast_nullable_to_non_nullable
              as BottomTabEnum,
    ));
  }
}

/// @nodoc

class _$_TabState implements _TabState {
  _$_TabState({this.currentIndex = 0, this.currentTab = BottomTabEnum.home});

  @JsonKey()
  @override
  final int currentIndex;
  @JsonKey()
  @override
  final BottomTabEnum currentTab;

  @override
  String toString() {
    return 'BottomNavigationBarState(currentIndex: $currentIndex, currentTab: $currentTab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TabState &&
            const DeepCollectionEquality()
                .equals(other.currentIndex, currentIndex) &&
            const DeepCollectionEquality()
                .equals(other.currentTab, currentTab));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(currentIndex),
      const DeepCollectionEquality().hash(currentTab));

  @JsonKey(ignore: true)
  @override
  _$TabStateCopyWith<_TabState> get copyWith =>
      __$TabStateCopyWithImpl<_TabState>(this, _$identity);
}

abstract class _TabState implements BottomNavigationBarState {
  factory _TabState({int currentIndex, BottomTabEnum currentTab}) = _$_TabState;

  @override
  int get currentIndex;
  @override
  BottomTabEnum get currentTab;
  @override
  @JsonKey(ignore: true)
  _$TabStateCopyWith<_TabState> get copyWith =>
      throw _privateConstructorUsedError;
}
