import 'dart:async';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../user/host.dart';
import '../user/user_mode.dart';
import '../user/worker.dart';
import 'chat_room_state.dart';

/// 指定した [ChatRoom] を取得する [FutureProvider].
final chatRoomFutureProvider =
    FutureProvider.family.autoDispose<ReadChatRoom?, String>(
  (ref, chatRoomId) => ref
      .watch(chatRoomRepositoryProvider)
      .fetchChatRoom(chatRoomId: chatRoomId),
);

/// チャット相手の画像 URL を取得する [Provider].
final chatPartnerImageUrlProvider =
    Provider.family.autoDispose<String, ReadChatRoom>((ref, readChatRoom) {
  final userMode = ref.watch(userModeStateProvider);
  switch (userMode) {
    case UserMode.worker:
      return ref.watch(hostImageUrlProvider(readChatRoom.hostId));
    case UserMode.host:
      return ref.watch(workerImageUrlProvider(readChatRoom.workerId));
  }
});

final chatRoomStateNotifierProvider =
    StateNotifierProvider.autoDispose<ChatRoomStateNotifier, ChatRoomState>(
  (ref) => ChatRoomStateNotifier(
    // TODO: パスパラメータから渡せるようにする
    chatRoomId: 'aSNYpkUofu05nyasvMRx',
    chatMessageRepository: ref.watch(chatMessageRepositoryProvider),
  ),
);

class ChatRoomStateNotifier extends StateNotifier<ChatRoomState> {
  ChatRoomStateNotifier({
    required String chatRoomId,
    required ChatMessageRepository chatMessageRepository,
  })  : _chatRoomId = chatRoomId,
        _chatMessageRepository = chatMessageRepository,
        super(const ChatRoomState()) {
    _newReadChatMessagesSubscription = _chatMessageRepository
        .subscribeChatMessages(
          chatRoomId: _chatRoomId,
          startDateTime: _startDateTime,
        )
        .listen(_updateNewReadChatMessages);
    Future<void>(() async {
      await Future.wait<void>([
        loadMore(),
        // ChatPage に遷移直後のメッセージアイコンを意図的に見せるために最低でも 500 ms 待つ。
        Future<void>.delayed(const Duration(milliseconds: 500)),
      ]);
      state = state.copyWith(loading: false);
    });
  }

  @override
  void dispose() {
    _newReadChatMessagesSubscription.cancel();
    super.dispose();
  }

  /// [ChatMessageRepository] のインスタンス。
  late final ChatMessageRepository _chatMessageRepository;

  /// チャットルームの ID。
  final String _chatRoomId;

  /// 無限スクロールで取得するメッセージ件数の limit 値。
  static const _limit = 10;

  /// この時刻以降のメッセージを新たなメッセージとしてリアルタイム取得する。
  final _startDateTime = DateTime.now();

  /// 新着メッセージの [StreamSubscription].
  /// リスナーで state.newReadChatMessages を更新する。
  late final StreamSubscription<List<ReadChatMessage>>
      _newReadChatMessagesSubscription;

  /// 過去のメッセージを、最後に取得した queryDocumentSnapshot 以降の _limit 件だけ取得する。
  Future<void> loadMore() async {
    if (!state.hasMore) {
      state = state.copyWith(fetching: false);
      return;
    }
    if (state.fetching) {
      return;
    }
    state = state.copyWith(fetching: true);
    final (readChatMessages, lastReadChatMessageId, hasMore) =
        await _chatMessageRepository.loadMessagesWithDocumentIdCursor(
      limit: _limit,
      chatRoomId: _chatRoomId,
      lastReadChatMessageId: state.lastReadChatMessageId,
    );
    _updatePastReadChatMessages(
      [...state.pastReadChatMessages, ...readChatMessages],
    );
    state = state.copyWith(
      fetching: false,
      lastReadChatMessageId: lastReadChatMessageId,
      hasMore: hasMore,
    );
  }

  /// チャットルーム画面に遷移した後に新たに取得したメッセージを更新した後、
  /// 取得したメッセージ全体も更新する。
  void _updateNewReadChatMessages(List<ReadChatMessage> newReadChatMessages) {
    state = state.copyWith(newReadChatMessages: newReadChatMessages);
    _updateReadChatMessages();
  }

  /// チャットルーム画面を遡って取得した過去のメッセージを更新した後、
  /// 取得したメッセージ全体も更新する。
  void _updatePastReadChatMessages(List<ReadChatMessage> pastReadChatMessages) {
    state = state.copyWith(pastReadChatMessages: pastReadChatMessages);
    _updateReadChatMessages();
  }

  /// 取得したメッセージ全体を更新する。
  void _updateReadChatMessages() {
    state = state.copyWith(
      readChatMessages: [
        ...state.newReadChatMessages,
        ...state.pastReadChatMessages
      ],
    );
  }

  /// [ChatMessage] を送信する。
  Future<void> sendChatMessage({
    required String senderId,
    required ChatMessageType chatMessageType,
    required String content,
    List<String> imageUrls = const <String>[],
  }) =>
      _chatMessageRepository.addChatMessage(
        chatRoomId: _chatRoomId,
        senderId: senderId,
        chatMessageType: chatMessageType,
        content: content,
        imageUrls: imageUrls,
      );
}
