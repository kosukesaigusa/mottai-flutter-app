// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'hero_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HeroItem {
  String get tag => throw _privateConstructorUsedError;
  String get imageURL => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HeroItemCopyWith<HeroItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeroItemCopyWith<$Res> {
  factory $HeroItemCopyWith(HeroItem value, $Res Function(HeroItem) then) =
      _$HeroItemCopyWithImpl<$Res>;
  $Res call({String tag, String imageURL, String description});
}

/// @nodoc
class _$HeroItemCopyWithImpl<$Res> implements $HeroItemCopyWith<$Res> {
  _$HeroItemCopyWithImpl(this._value, this._then);

  final HeroItem _value;
  // ignore: unused_field
  final $Res Function(HeroItem) _then;

  @override
  $Res call({
    Object? tag = freezed,
    Object? imageURL = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      tag: tag == freezed
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_HeroItemCopyWith<$Res> implements $HeroItemCopyWith<$Res> {
  factory _$$_HeroItemCopyWith(
          _$_HeroItem value, $Res Function(_$_HeroItem) then) =
      __$$_HeroItemCopyWithImpl<$Res>;
  @override
  $Res call({String tag, String imageURL, String description});
}

/// @nodoc
class __$$_HeroItemCopyWithImpl<$Res> extends _$HeroItemCopyWithImpl<$Res>
    implements _$$_HeroItemCopyWith<$Res> {
  __$$_HeroItemCopyWithImpl(
      _$_HeroItem _value, $Res Function(_$_HeroItem) _then)
      : super(_value, (v) => _then(v as _$_HeroItem));

  @override
  _$_HeroItem get _value => super._value as _$_HeroItem;

  @override
  $Res call({
    Object? tag = freezed,
    Object? imageURL = freezed,
    Object? description = freezed,
  }) {
    return _then(_$_HeroItem(
      tag: tag == freezed
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_HeroItem implements _HeroItem {
  const _$_HeroItem(
      {required this.tag, this.imageURL = '', this.description = ''});

  @override
  final String tag;
  @override
  @JsonKey()
  final String imageURL;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'HeroItem(tag: $tag, imageURL: $imageURL, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HeroItem &&
            const DeepCollectionEquality().equals(other.tag, tag) &&
            const DeepCollectionEquality().equals(other.imageURL, imageURL) &&
            const DeepCollectionEquality()
                .equals(other.description, description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tag),
      const DeepCollectionEquality().hash(imageURL),
      const DeepCollectionEquality().hash(description));

  @JsonKey(ignore: true)
  @override
  _$$_HeroItemCopyWith<_$_HeroItem> get copyWith =>
      __$$_HeroItemCopyWithImpl<_$_HeroItem>(this, _$identity);
}

abstract class _HeroItem implements HeroItem {
  const factory _HeroItem(
      {required final String tag,
      final String imageURL,
      final String description}) = _$_HeroItem;

  @override
  String get tag => throw _privateConstructorUsedError;
  @override
  String get imageURL => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_HeroItemCopyWith<_$_HeroItem> get copyWith =>
      throw _privateConstructorUsedError;
}
