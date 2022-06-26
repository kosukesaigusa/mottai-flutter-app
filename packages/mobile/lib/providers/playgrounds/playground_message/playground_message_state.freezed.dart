// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playground_message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaygroundMessageState {
  bool get loading => throw _privateConstructorUsedError;
  List<PlaygroundMessage> get messages => throw _privateConstructorUsedError;
  List<PlaygroundMessage> get newMessages => throw _privateConstructorUsedError;
  List<PlaygroundMessage> get pastMessages =>
      throw _privateConstructorUsedError;
  bool get fetching => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  QueryDocumentSnapshot<PlaygroundMessage>? get lastVisibleQds =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaygroundMessageStateCopyWith<PlaygroundMessageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaygroundMessageStateCopyWith<$Res> {
  factory $PlaygroundMessageStateCopyWith(PlaygroundMessageState value,
          $Res Function(PlaygroundMessageState) then) =
      _$PlaygroundMessageStateCopyWithImpl<$Res>;
  $Res call(
      {bool loading,
      List<PlaygroundMessage> messages,
      List<PlaygroundMessage> newMessages,
      List<PlaygroundMessage> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<PlaygroundMessage>? lastVisibleQds});
}

/// @nodoc
class _$PlaygroundMessageStateCopyWithImpl<$Res>
    implements $PlaygroundMessageStateCopyWith<$Res> {
  _$PlaygroundMessageStateCopyWithImpl(this._value, this._then);

  final PlaygroundMessageState _value;
  // ignore: unused_field
  final $Res Function(PlaygroundMessageState) _then;

  @override
  $Res call({
    Object? loading = freezed,
    Object? messages = freezed,
    Object? newMessages = freezed,
    Object? pastMessages = freezed,
    Object? fetching = freezed,
    Object? hasMore = freezed,
    Object? lastVisibleQds = freezed,
  }) {
    return _then(_value.copyWith(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      newMessages: newMessages == freezed
          ? _value.newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      pastMessages: pastMessages == freezed
          ? _value.pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      fetching: fetching == freezed
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastVisibleQds: lastVisibleQds == freezed
          ? _value.lastVisibleQds
          : lastVisibleQds // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<PlaygroundMessage>?,
    ));
  }
}

/// @nodoc
abstract class _$$_PlaygroundMessageStateCopyWith<$Res>
    implements $PlaygroundMessageStateCopyWith<$Res> {
  factory _$$_PlaygroundMessageStateCopyWith(_$_PlaygroundMessageState value,
          $Res Function(_$_PlaygroundMessageState) then) =
      __$$_PlaygroundMessageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool loading,
      List<PlaygroundMessage> messages,
      List<PlaygroundMessage> newMessages,
      List<PlaygroundMessage> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<PlaygroundMessage>? lastVisibleQds});
}

/// @nodoc
class __$$_PlaygroundMessageStateCopyWithImpl<$Res>
    extends _$PlaygroundMessageStateCopyWithImpl<$Res>
    implements _$$_PlaygroundMessageStateCopyWith<$Res> {
  __$$_PlaygroundMessageStateCopyWithImpl(_$_PlaygroundMessageState _value,
      $Res Function(_$_PlaygroundMessageState) _then)
      : super(_value, (v) => _then(v as _$_PlaygroundMessageState));

  @override
  _$_PlaygroundMessageState get _value =>
      super._value as _$_PlaygroundMessageState;

  @override
  $Res call({
    Object? loading = freezed,
    Object? messages = freezed,
    Object? newMessages = freezed,
    Object? pastMessages = freezed,
    Object? fetching = freezed,
    Object? hasMore = freezed,
    Object? lastVisibleQds = freezed,
  }) {
    return _then(_$_PlaygroundMessageState(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: messages == freezed
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      newMessages: newMessages == freezed
          ? _value._newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      pastMessages: pastMessages == freezed
          ? _value._pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<PlaygroundMessage>,
      fetching: fetching == freezed
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: hasMore == freezed
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastVisibleQds: lastVisibleQds == freezed
          ? _value.lastVisibleQds
          : lastVisibleQds // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<PlaygroundMessage>?,
    ));
  }
}

/// @nodoc

class _$_PlaygroundMessageState implements _PlaygroundMessageState {
  const _$_PlaygroundMessageState(
      {this.loading = true,
      final List<PlaygroundMessage> messages = const <PlaygroundMessage>[],
      final List<PlaygroundMessage> newMessages = const <PlaygroundMessage>[],
      final List<PlaygroundMessage> pastMessages = const <PlaygroundMessage>[],
      this.fetching = false,
      this.hasMore = true,
      this.lastVisibleQds})
      : _messages = messages,
        _newMessages = newMessages,
        _pastMessages = pastMessages;

  @override
  @JsonKey()
  final bool loading;
  final List<PlaygroundMessage> _messages;
  @override
  @JsonKey()
  List<PlaygroundMessage> get messages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  final List<PlaygroundMessage> _newMessages;
  @override
  @JsonKey()
  List<PlaygroundMessage> get newMessages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newMessages);
  }

  final List<PlaygroundMessage> _pastMessages;
  @override
  @JsonKey()
  List<PlaygroundMessage> get pastMessages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastMessages);
  }

  @override
  @JsonKey()
  final bool fetching;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final QueryDocumentSnapshot<PlaygroundMessage>? lastVisibleQds;

  @override
  String toString() {
    return 'PlaygroundMessageState(loading: $loading, messages: $messages, newMessages: $newMessages, pastMessages: $pastMessages, fetching: $fetching, hasMore: $hasMore, lastVisibleQds: $lastVisibleQds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaygroundMessageState &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            const DeepCollectionEquality()
                .equals(other._newMessages, _newMessages) &&
            const DeepCollectionEquality()
                .equals(other._pastMessages, _pastMessages) &&
            const DeepCollectionEquality().equals(other.fetching, fetching) &&
            const DeepCollectionEquality().equals(other.hasMore, hasMore) &&
            const DeepCollectionEquality()
                .equals(other.lastVisibleQds, lastVisibleQds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(loading),
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_newMessages),
      const DeepCollectionEquality().hash(_pastMessages),
      const DeepCollectionEquality().hash(fetching),
      const DeepCollectionEquality().hash(hasMore),
      const DeepCollectionEquality().hash(lastVisibleQds));

  @JsonKey(ignore: true)
  @override
  _$$_PlaygroundMessageStateCopyWith<_$_PlaygroundMessageState> get copyWith =>
      __$$_PlaygroundMessageStateCopyWithImpl<_$_PlaygroundMessageState>(
          this, _$identity);
}

abstract class _PlaygroundMessageState implements PlaygroundMessageState {
  const factory _PlaygroundMessageState(
          {final bool loading,
          final List<PlaygroundMessage> messages,
          final List<PlaygroundMessage> newMessages,
          final List<PlaygroundMessage> pastMessages,
          final bool fetching,
          final bool hasMore,
          final QueryDocumentSnapshot<PlaygroundMessage>? lastVisibleQds}) =
      _$_PlaygroundMessageState;

  @override
  bool get loading => throw _privateConstructorUsedError;
  @override
  List<PlaygroundMessage> get messages => throw _privateConstructorUsedError;
  @override
  List<PlaygroundMessage> get newMessages => throw _privateConstructorUsedError;
  @override
  List<PlaygroundMessage> get pastMessages =>
      throw _privateConstructorUsedError;
  @override
  bool get fetching => throw _privateConstructorUsedError;
  @override
  bool get hasMore => throw _privateConstructorUsedError;
  @override
  QueryDocumentSnapshot<PlaygroundMessage>? get lastVisibleQds =>
      throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_PlaygroundMessageStateCopyWith<_$_PlaygroundMessageState> get copyWith =>
      throw _privateConstructorUsedError;
}
