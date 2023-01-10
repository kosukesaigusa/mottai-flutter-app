// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'union_timestamp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UnionTimestamp {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime dateTime) dateTime,
    required TResult Function() serverTimestamp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateTime)? dateTime,
    TResult? Function()? serverTimestamp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateTime)? dateTime,
    TResult Function()? serverTimestamp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnionDateTime value) dateTime,
    required TResult Function(UnionServerTimestamp value) serverTimestamp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnionDateTime value)? dateTime,
    TResult? Function(UnionServerTimestamp value)? serverTimestamp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnionDateTime value)? dateTime,
    TResult Function(UnionServerTimestamp value)? serverTimestamp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnionTimestampCopyWith<$Res> {
  factory $UnionTimestampCopyWith(
          UnionTimestamp value, $Res Function(UnionTimestamp) then) =
      _$UnionTimestampCopyWithImpl<$Res, UnionTimestamp>;
}

/// @nodoc
class _$UnionTimestampCopyWithImpl<$Res, $Val extends UnionTimestamp>
    implements $UnionTimestampCopyWith<$Res> {
  _$UnionTimestampCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$UnionDateTimeCopyWith<$Res> {
  factory _$$UnionDateTimeCopyWith(
          _$UnionDateTime value, $Res Function(_$UnionDateTime) then) =
      __$$UnionDateTimeCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime dateTime});
}

/// @nodoc
class __$$UnionDateTimeCopyWithImpl<$Res>
    extends _$UnionTimestampCopyWithImpl<$Res, _$UnionDateTime>
    implements _$$UnionDateTimeCopyWith<$Res> {
  __$$UnionDateTimeCopyWithImpl(
      _$UnionDateTime _value, $Res Function(_$UnionDateTime) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
  }) {
    return _then(_$UnionDateTime(
      null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$UnionDateTime extends UnionDateTime {
  const _$UnionDateTime(this.dateTime) : super._();

  @override
  final DateTime dateTime;

  @override
  String toString() {
    return 'UnionTimestamp.dateTime(dateTime: $dateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnionDateTime &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnionDateTimeCopyWith<_$UnionDateTime> get copyWith =>
      __$$UnionDateTimeCopyWithImpl<_$UnionDateTime>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime dateTime) dateTime,
    required TResult Function() serverTimestamp,
  }) {
    return dateTime(this.dateTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateTime)? dateTime,
    TResult? Function()? serverTimestamp,
  }) {
    return dateTime?.call(this.dateTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateTime)? dateTime,
    TResult Function()? serverTimestamp,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(this.dateTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnionDateTime value) dateTime,
    required TResult Function(UnionServerTimestamp value) serverTimestamp,
  }) {
    return dateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnionDateTime value)? dateTime,
    TResult? Function(UnionServerTimestamp value)? serverTimestamp,
  }) {
    return dateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnionDateTime value)? dateTime,
    TResult Function(UnionServerTimestamp value)? serverTimestamp,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(this);
    }
    return orElse();
  }
}

abstract class UnionDateTime extends UnionTimestamp {
  const factory UnionDateTime(final DateTime dateTime) = _$UnionDateTime;
  const UnionDateTime._() : super._();

  DateTime get dateTime;
  @JsonKey(ignore: true)
  _$$UnionDateTimeCopyWith<_$UnionDateTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnionServerTimestampCopyWith<$Res> {
  factory _$$UnionServerTimestampCopyWith(_$UnionServerTimestamp value,
          $Res Function(_$UnionServerTimestamp) then) =
      __$$UnionServerTimestampCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnionServerTimestampCopyWithImpl<$Res>
    extends _$UnionTimestampCopyWithImpl<$Res, _$UnionServerTimestamp>
    implements _$$UnionServerTimestampCopyWith<$Res> {
  __$$UnionServerTimestampCopyWithImpl(_$UnionServerTimestamp _value,
      $Res Function(_$UnionServerTimestamp) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UnionServerTimestamp extends UnionServerTimestamp {
  const _$UnionServerTimestamp() : super._();

  @override
  String toString() {
    return 'UnionTimestamp.serverTimestamp()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnionServerTimestamp);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime dateTime) dateTime,
    required TResult Function() serverTimestamp,
  }) {
    return serverTimestamp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime dateTime)? dateTime,
    TResult? Function()? serverTimestamp,
  }) {
    return serverTimestamp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime dateTime)? dateTime,
    TResult Function()? serverTimestamp,
    required TResult orElse(),
  }) {
    if (serverTimestamp != null) {
      return serverTimestamp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnionDateTime value) dateTime,
    required TResult Function(UnionServerTimestamp value) serverTimestamp,
  }) {
    return serverTimestamp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnionDateTime value)? dateTime,
    TResult? Function(UnionServerTimestamp value)? serverTimestamp,
  }) {
    return serverTimestamp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnionDateTime value)? dateTime,
    TResult Function(UnionServerTimestamp value)? serverTimestamp,
    required TResult orElse(),
  }) {
    if (serverTimestamp != null) {
      return serverTimestamp(this);
    }
    return orElse();
  }
}

abstract class UnionServerTimestamp extends UnionTimestamp {
  const factory UnionServerTimestamp() = _$UnionServerTimestamp;
  const UnionServerTimestamp._() : super._();
}
