import 'package:firebase_common/firebase_common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_state.freezed.dart';

@freezed
class ChatRoomState with _$ChatRoomState {
  const factory ChatRoomState({
    /// チャットページに入ったときの初回ローディング中かどうか。
    @Default(true) bool loading,

    /// チャットルーム。初回ローディングで取得することを期待する。
    ReadChatRoom? readChatRoom,

    /// メッセージを送信中かどうか。
    @Default(false) bool sending,

    /// 取得したメッセージ全体。
    @Default(<ReadChatMessage>[]) List<ReadChatMessage> readChatMessages,

    /// 取得した新着メッセージ。
    @Default(<ReadChatMessage>[]) List<ReadChatMessage> newReadChatMessages,

    /// 遡って取得した過去のメッセージ。
    @Default(<ReadChatMessage>[]) List<ReadChatMessage> pastReadChatMessages,

    /// 無限スクロールで遡って過去のメッセージを取得中かどうか。
    @Default(false) bool fetching,

    /// 無限スクロールで遡る際にまだ取得するメッセージが残っているかどうか。
    @Default(true) bool hasMore,

    /// 無限スクロールで遡って取得した最後の [ChatMessage] ドキュメントの ID.
    String? lastReadChatMessageId,
  }) = _ChatRoomState;
}
