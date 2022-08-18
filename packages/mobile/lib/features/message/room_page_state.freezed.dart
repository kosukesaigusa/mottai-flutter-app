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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RoomPageState {
  bool get loading => throw _privateConstructorUsedError;
  bool get sending => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;
  List<Message> get messages => throw _privateConstructorUsedError;
  List<Message> get newMessages => throw _privateConstructorUsedError;
  List<Message> get pastMessages => throw _privateConstructorUsedError;
  bool get fetching => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  QueryDocumentSnapshot<Message>? get lastVisibleQds =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoomPageStateCopyWith<RoomPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomPageStateCopyWith<$Res> {
  factory $RoomPageStateCopyWith(
          RoomPageState value, $Res Function(RoomPageState) then) =
      _$RoomPageStateCopyWithImpl<$Res>;
  $Res call(
      {bool loading,
      bool sending,
      bool isValid,
      List<Message> messages,
      List<Message> newMessages,
      List<Message> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<Message>? lastVisibleQds});
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
    Object? isValid = freezed,
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
      sending: sending == freezed
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: isValid == freezed
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: messages == freezed
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      newMessages: newMessages == freezed
          ? _value.newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      pastMessages: pastMessages == freezed
          ? _value.pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
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
              as QueryDocumentSnapshot<Message>?,
    ));
  }
}

/// @nodoc
abstract class _$$_RoomPageStateCopyWith<$Res>
    implements $RoomPageStateCopyWith<$Res> {
  factory _$$_RoomPageStateCopyWith(
          _$_RoomPageState value, $Res Function(_$_RoomPageState) then) =
      __$$_RoomPageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool loading,
      bool sending,
      bool isValid,
      List<Message> messages,
      List<Message> newMessages,
      List<Message> pastMessages,
      bool fetching,
      bool hasMore,
      QueryDocumentSnapshot<Message>? lastVisibleQds});
}

/// @nodoc
class __$$_RoomPageStateCopyWithImpl<$Res>
    extends _$RoomPageStateCopyWithImpl<$Res>
    implements _$$_RoomPageStateCopyWith<$Res> {
  __$$_RoomPageStateCopyWithImpl(
      _$_RoomPageState _value, $Res Function(_$_RoomPageState) _then)
      : super(_value, (v) => _then(v as _$_RoomPageState));

  @override
  _$_RoomPageState get _value => super._value as _$_RoomPageState;

  @override
  $Res call({
    Object? loading = freezed,
    Object? sending = freezed,
    Object? isValid = freezed,
    Object? messages = freezed,
    Object? newMessages = freezed,
    Object? pastMessages = freezed,
    Object? fetching = freezed,
    Object? hasMore = freezed,
    Object? lastVisibleQds = freezed,
  }) {
    return _then(_$_RoomPageState(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sending: sending == freezed
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: isValid == freezed
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      messages: messages == freezed
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      newMessages: newMessages == freezed
          ? _value._newMessages
          : newMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      pastMessages: pastMessages == freezed
          ? _value._pastMessages
          : pastMessages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
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
              as QueryDocumentSnapshot<Message>?,
    ));
  }
}

/// @nodoc

class _$_RoomPageState implements _RoomPageState {
  const _$_RoomPageState(
      {this.loading = true,
      this.sending = false,
      this.isValid = false,
      final List<Message> messages = const <Message>[],
      final List<Message> newMessages = const <Message>[],
      final List<Message> pastMessages = const <Message>[],
      this.fetching = false,
      this.hasMore = true,
      this.lastVisibleQds})
      : _messages = messages,
        _newMessages = newMessages,
        _pastMessages = pastMessages;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool sending;
  @override
  @JsonKey()
  final bool isValid;
  final List<Message> _messages;
  @override
  @JsonKey()
  List<Message> get messages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  final List<Message> _newMessages;
  @override
  @JsonKey()
  List<Message> get newMessages {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newMessages);
  }

  final List<Message> _pastMessages;
  @override
  @JsonKey()
  List<Message> get pastMessages {
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
  final QueryDocumentSnapshot<Message>? lastVisibleQds;

  @override
  String toString() {
    return 'RoomPageState(loading: $loading, sending: $sending, isValid: $isValid, messages: $messages, newMessages: $newMessages, pastMessages: $pastMessages, fetching: $fetching, hasMore: $hasMore, lastVisibleQds: $lastVisibleQds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RoomPageState &&
            const DeepCollectionEquality().equals(other.loading, loading) &&
            const DeepCollectionEquality().equals(other.sending, sending) &&
            const DeepCollectionEquality().equals(other.isValid, isValid) &&
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
      const DeepCollectionEquality().hash(sending),
      const DeepCollectionEquality().hash(isValid),
      const DeepCollectionEquality().hash(_messages),
      const DeepCollectionEquality().hash(_newMessages),
      const DeepCollectionEquality().hash(_pastMessages),
      const DeepCollectionEquality().hash(fetching),
      const DeepCollectionEquality().hash(hasMore),
      const DeepCollectionEquality().hash(lastVisibleQds));

  @JsonKey(ignore: true)
  @override
  _$$_RoomPageStateCopyWith<_$_RoomPageState> get copyWith =>
      __$$_RoomPageStateCopyWithImpl<_$_RoomPageState>(this, _$identity);
}

abstract class _RoomPageState implements RoomPageState {
  const factory _RoomPageState(
      {final bool loading,
      final bool sending,
      final bool isValid,
      final List<Message> messages,
      final List<Message> newMessages,
      final List<Message> pastMessages,
      final bool fetching,
      final bool hasMore,
      final QueryDocumentSnapshot<Message>? lastVisibleQds}) = _$_RoomPageState;

  @override
  bool get loading;
  @override
  bool get sending;
  @override
  bool get isValid;
  @override
  List<Message> get messages;
  @override
  List<Message> get newMessages;
  @override
  List<Message> get pastMessages;
  @override
  bool get fetching;
  @override
  bool get hasMore;
  @override
  QueryDocumentSnapshot<Message>? get lastVisibleQds;
  @override
  @JsonKey(ignore: true)
  _$$_RoomPageStateCopyWith<_$_RoomPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
