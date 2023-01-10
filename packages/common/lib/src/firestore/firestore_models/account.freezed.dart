// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  String get accountId => throw _privateConstructorUsedError;
  @unionTimestampConverter
  UnionTimestamp get createdAt => throw _privateConstructorUsedError;
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get updatedAt => throw _privateConstructorUsedError;
  bool get isHost => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get imageURL =>
      throw _privateConstructorUsedError; // TODO: Enum のコンバータを実装する。
  List<String> get signInMethods => throw _privateConstructorUsedError;
  List<String> get fcmTokens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String accountId,
      @unionTimestampConverter UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter UnionTimestamp updatedAt,
      bool isHost,
      String displayName,
      String imageURL,
      List<String> signInMethods,
      List<String> fcmTokens});

  $UnionTimestampCopyWith<$Res> get createdAt;
  $UnionTimestampCopyWith<$Res> get updatedAt;
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isHost = null,
    Object? displayName = null,
    Object? imageURL = null,
    Object? signInMethods = null,
    Object? fcmTokens = null,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      isHost: null == isHost
          ? _value.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: null == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      signInMethods: null == signInMethods
          ? _value.signInMethods
          : signInMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fcmTokens: null == fcmTokens
          ? _value.fcmTokens
          : fcmTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
}

/// @nodoc
abstract class _$$_AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$_AccountCopyWith(
          _$_Account value, $Res Function(_$_Account) then) =
      __$$_AccountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      @unionTimestampConverter UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter UnionTimestamp updatedAt,
      bool isHost,
      String displayName,
      String imageURL,
      List<String> signInMethods,
      List<String> fcmTokens});

  @override
  $UnionTimestampCopyWith<$Res> get createdAt;
  @override
  $UnionTimestampCopyWith<$Res> get updatedAt;
}

/// @nodoc
class __$$_AccountCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$_Account>
    implements _$$_AccountCopyWith<$Res> {
  __$$_AccountCopyWithImpl(_$_Account _value, $Res Function(_$_Account) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isHost = null,
    Object? displayName = null,
    Object? imageURL = null,
    Object? signInMethods = null,
    Object? fcmTokens = null,
  }) {
    return _then(_$_Account(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as UnionTimestamp,
      isHost: null == isHost
          ? _value.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: null == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      signInMethods: null == signInMethods
          ? _value._signInMethods
          : signInMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fcmTokens: null == fcmTokens
          ? _value._fcmTokens
          : fcmTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Account implements _Account {
  const _$_Account(
      {this.accountId = '',
      @unionTimestampConverter
          this.createdAt = const UnionTimestamp.serverTimestamp(),
      @alwaysUseServerTimestampUnionTimestampConverter
          this.updatedAt = const UnionTimestamp.serverTimestamp(),
      this.isHost = false,
      this.displayName = '',
      this.imageURL = '',
      final List<String> signInMethods = const <String>[],
      final List<String> fcmTokens = const <String>[]})
      : _signInMethods = signInMethods,
        _fcmTokens = fcmTokens;

  factory _$_Account.fromJson(Map<String, dynamic> json) =>
      _$$_AccountFromJson(json);

  @override
  @JsonKey()
  final String accountId;
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
  final bool isHost;
  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String imageURL;
// TODO: Enum のコンバータを実装する。
  final List<String> _signInMethods;
// TODO: Enum のコンバータを実装する。
  @override
  @JsonKey()
  List<String> get signInMethods {
    if (_signInMethods is EqualUnmodifiableListView) return _signInMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_signInMethods);
  }

  final List<String> _fcmTokens;
  @override
  @JsonKey()
  List<String> get fcmTokens {
    if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fcmTokens);
  }

  @override
  String toString() {
    return 'Account(accountId: $accountId, createdAt: $createdAt, updatedAt: $updatedAt, isHost: $isHost, displayName: $displayName, imageURL: $imageURL, signInMethods: $signInMethods, fcmTokens: $fcmTokens)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Account &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isHost, isHost) || other.isHost == isHost) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.imageURL, imageURL) ||
                other.imageURL == imageURL) &&
            const DeepCollectionEquality()
                .equals(other._signInMethods, _signInMethods) &&
            const DeepCollectionEquality()
                .equals(other._fcmTokens, _fcmTokens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accountId,
      createdAt,
      updatedAt,
      isHost,
      displayName,
      imageURL,
      const DeepCollectionEquality().hash(_signInMethods),
      const DeepCollectionEquality().hash(_fcmTokens));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      __$$_AccountCopyWithImpl<_$_Account>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AccountToJson(
      this,
    );
  }
}

abstract class _Account implements Account {
  const factory _Account(
      {final String accountId,
      @unionTimestampConverter
          final UnionTimestamp createdAt,
      @alwaysUseServerTimestampUnionTimestampConverter
          final UnionTimestamp updatedAt,
      final bool isHost,
      final String displayName,
      final String imageURL,
      final List<String> signInMethods,
      final List<String> fcmTokens}) = _$_Account;

  factory _Account.fromJson(Map<String, dynamic> json) = _$_Account.fromJson;

  @override
  String get accountId;
  @override
  @unionTimestampConverter
  UnionTimestamp get createdAt;
  @override
  @alwaysUseServerTimestampUnionTimestampConverter
  UnionTimestamp get updatedAt;
  @override
  bool get isHost;
  @override
  String get displayName;
  @override
  String get imageURL;
  @override // TODO: Enum のコンバータを実装する。
  List<String> get signInMethods;
  @override
  List<String> get fcmTokens;
  @override
  @JsonKey(ignore: true)
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      throw _privateConstructorUsedError;
}
