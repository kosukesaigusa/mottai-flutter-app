// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatRoomState {
  /// チャットページに入ったときの初回ローディング中かどうか。
  bool get loading => throw _privateConstructorUsedError;

  /// チャットルーム。初回ローディングで取得することを期待する。
  ReadChatRoom? get readChatRoom => throw _privateConstructorUsedError;

  /// メッセージを送信中かどうか。
  bool get sending => throw _privateConstructorUsedError;

  /// 取得したメッセージ全体。
  List<ReadChatMessage> get readChatMessages =>
      throw _privateConstructorUsedError;

  /// 取得した新着メッセージ。
  List<ReadChatMessage> get newReadChatMessages =>
      throw _privateConstructorUsedError;

  /// 遡って取得した過去のメッセージ。
  List<ReadChatMessage> get pastReadChatMessages =>
      throw _privateConstructorUsedError;

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  bool get fetching => throw _privateConstructorUsedError;

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  bool get hasMore => throw _privateConstructorUsedError;

  /// 無限スクロールで遡って取得した最後の [ChatMessage] ドキュメントの ID.
  String? get lastReadChatMessageId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatRoomStateCopyWith<ChatRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomStateCopyWith<$Res> {
  factory $ChatRoomStateCopyWith(
          ChatRoomState value, $Res Function(ChatRoomState) then) =
      _$ChatRoomStateCopyWithImpl<$Res, ChatRoomState>;
  @useResult
  $Res call(
      {bool loading,
      ReadChatRoom? readChatRoom,
      bool sending,
      List<ReadChatMessage> readChatMessages,
      List<ReadChatMessage> newReadChatMessages,
      List<ReadChatMessage> pastReadChatMessages,
      bool fetching,
      bool hasMore,
      String? lastReadChatMessageId});
}

/// @nodoc
class _$ChatRoomStateCopyWithImpl<$Res, $Val extends ChatRoomState>
    implements $ChatRoomStateCopyWith<$Res> {
  _$ChatRoomStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? readChatRoom = freezed,
    Object? sending = null,
    Object? readChatMessages = null,
    Object? newReadChatMessages = null,
    Object? pastReadChatMessages = null,
    Object? fetching = null,
    Object? hasMore = null,
    Object? lastReadChatMessageId = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      readChatRoom: freezed == readChatRoom
          ? _value.readChatRoom
          : readChatRoom // ignore: cast_nullable_to_non_nullable
              as ReadChatRoom?,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      readChatMessages: null == readChatMessages
          ? _value.readChatMessages
          : readChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      newReadChatMessages: null == newReadChatMessages
          ? _value.newReadChatMessages
          : newReadChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      pastReadChatMessages: null == pastReadChatMessages
          ? _value.pastReadChatMessages
          : pastReadChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      fetching: null == fetching
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReadChatMessageId: freezed == lastReadChatMessageId
          ? _value.lastReadChatMessageId
          : lastReadChatMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatRoomStateCopyWith<$Res>
    implements $ChatRoomStateCopyWith<$Res> {
  factory _$$_ChatRoomStateCopyWith(
          _$_ChatRoomState value, $Res Function(_$_ChatRoomState) then) =
      __$$_ChatRoomStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      ReadChatRoom? readChatRoom,
      bool sending,
      List<ReadChatMessage> readChatMessages,
      List<ReadChatMessage> newReadChatMessages,
      List<ReadChatMessage> pastReadChatMessages,
      bool fetching,
      bool hasMore,
      String? lastReadChatMessageId});
}

/// @nodoc
class __$$_ChatRoomStateCopyWithImpl<$Res>
    extends _$ChatRoomStateCopyWithImpl<$Res, _$_ChatRoomState>
    implements _$$_ChatRoomStateCopyWith<$Res> {
  __$$_ChatRoomStateCopyWithImpl(
      _$_ChatRoomState _value, $Res Function(_$_ChatRoomState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? readChatRoom = freezed,
    Object? sending = null,
    Object? readChatMessages = null,
    Object? newReadChatMessages = null,
    Object? pastReadChatMessages = null,
    Object? fetching = null,
    Object? hasMore = null,
    Object? lastReadChatMessageId = freezed,
  }) {
    return _then(_$_ChatRoomState(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      readChatRoom: freezed == readChatRoom
          ? _value.readChatRoom
          : readChatRoom // ignore: cast_nullable_to_non_nullable
              as ReadChatRoom?,
      sending: null == sending
          ? _value.sending
          : sending // ignore: cast_nullable_to_non_nullable
              as bool,
      readChatMessages: null == readChatMessages
          ? _value._readChatMessages
          : readChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      newReadChatMessages: null == newReadChatMessages
          ? _value._newReadChatMessages
          : newReadChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      pastReadChatMessages: null == pastReadChatMessages
          ? _value._pastReadChatMessages
          : pastReadChatMessages // ignore: cast_nullable_to_non_nullable
              as List<ReadChatMessage>,
      fetching: null == fetching
          ? _value.fetching
          : fetching // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastReadChatMessageId: freezed == lastReadChatMessageId
          ? _value.lastReadChatMessageId
          : lastReadChatMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ChatRoomState implements _ChatRoomState {
  const _$_ChatRoomState(
      {this.loading = true,
      this.readChatRoom,
      this.sending = false,
      final List<ReadChatMessage> readChatMessages = const <ReadChatMessage>[],
      final List<ReadChatMessage> newReadChatMessages =
          const <ReadChatMessage>[],
      final List<ReadChatMessage> pastReadChatMessages =
          const <ReadChatMessage>[],
      this.fetching = false,
      this.hasMore = true,
      this.lastReadChatMessageId})
      : _readChatMessages = readChatMessages,
        _newReadChatMessages = newReadChatMessages,
        _pastReadChatMessages = pastReadChatMessages;

  /// チャットページに入ったときの初回ローディング中かどうか。
  @override
  @JsonKey()
  final bool loading;

  /// チャットルーム。初回ローディングで取得することを期待する。
  @override
  final ReadChatRoom? readChatRoom;

  /// メッセージを送信中かどうか。
  @override
  @JsonKey()
  final bool sending;

  /// 取得したメッセージ全体。
  final List<ReadChatMessage> _readChatMessages;

  /// 取得したメッセージ全体。
  @override
  @JsonKey()
  List<ReadChatMessage> get readChatMessages {
    if (_readChatMessages is EqualUnmodifiableListView)
      return _readChatMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readChatMessages);
  }

  /// 取得した新着メッセージ。
  final List<ReadChatMessage> _newReadChatMessages;

  /// 取得した新着メッセージ。
  @override
  @JsonKey()
  List<ReadChatMessage> get newReadChatMessages {
    if (_newReadChatMessages is EqualUnmodifiableListView)
      return _newReadChatMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newReadChatMessages);
  }

  /// 遡って取得した過去のメッセージ。
  final List<ReadChatMessage> _pastReadChatMessages;

  /// 遡って取得した過去のメッセージ。
  @override
  @JsonKey()
  List<ReadChatMessage> get pastReadChatMessages {
    if (_pastReadChatMessages is EqualUnmodifiableListView)
      return _pastReadChatMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastReadChatMessages);
  }

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  @override
  @JsonKey()
  final bool fetching;

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  @override
  @JsonKey()
  final bool hasMore;

  /// 無限スクロールで遡って取得した最後の [ChatMessage] ドキュメントの ID.
  @override
  final String? lastReadChatMessageId;

  @override
  String toString() {
    return 'ChatRoomState(loading: $loading, readChatRoom: $readChatRoom, sending: $sending, readChatMessages: $readChatMessages, newReadChatMessages: $newReadChatMessages, pastReadChatMessages: $pastReadChatMessages, fetching: $fetching, hasMore: $hasMore, lastReadChatMessageId: $lastReadChatMessageId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatRoomState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.readChatRoom, readChatRoom) ||
                other.readChatRoom == readChatRoom) &&
            (identical(other.sending, sending) || other.sending == sending) &&
            const DeepCollectionEquality()
                .equals(other._readChatMessages, _readChatMessages) &&
            const DeepCollectionEquality()
                .equals(other._newReadChatMessages, _newReadChatMessages) &&
            const DeepCollectionEquality()
                .equals(other._pastReadChatMessages, _pastReadChatMessages) &&
            (identical(other.fetching, fetching) ||
                other.fetching == fetching) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.lastReadChatMessageId, lastReadChatMessageId) ||
                other.lastReadChatMessageId == lastReadChatMessageId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      readChatRoom,
      sending,
      const DeepCollectionEquality().hash(_readChatMessages),
      const DeepCollectionEquality().hash(_newReadChatMessages),
      const DeepCollectionEquality().hash(_pastReadChatMessages),
      fetching,
      hasMore,
      lastReadChatMessageId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatRoomStateCopyWith<_$_ChatRoomState> get copyWith =>
      __$$_ChatRoomStateCopyWithImpl<_$_ChatRoomState>(this, _$identity);
}

abstract class _ChatRoomState implements ChatRoomState {
  const factory _ChatRoomState(
      {final bool loading,
      final ReadChatRoom? readChatRoom,
      final bool sending,
      final List<ReadChatMessage> readChatMessages,
      final List<ReadChatMessage> newReadChatMessages,
      final List<ReadChatMessage> pastReadChatMessages,
      final bool fetching,
      final bool hasMore,
      final String? lastReadChatMessageId}) = _$_ChatRoomState;

  @override

  /// チャットページに入ったときの初回ローディング中かどうか。
  bool get loading;
  @override

  /// チャットルーム。初回ローディングで取得することを期待する。
  ReadChatRoom? get readChatRoom;
  @override

  /// メッセージを送信中かどうか。
  bool get sending;
  @override

  /// 取得したメッセージ全体。
  List<ReadChatMessage> get readChatMessages;
  @override

  /// 取得した新着メッセージ。
  List<ReadChatMessage> get newReadChatMessages;
  @override

  /// 遡って取得した過去のメッセージ。
  List<ReadChatMessage> get pastReadChatMessages;
  @override

  /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
  bool get fetching;
  @override

  /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
  bool get hasMore;
  @override

  /// 無限スクロールで遡って取得した最後の [ChatMessage] ドキュメントの ID.
  String? get lastReadChatMessageId;
  @override
  @JsonKey(ignore: true)
  _$$_ChatRoomStateCopyWith<_$_ChatRoomState> get copyWith =>
      throw _privateConstructorUsedError;
}
