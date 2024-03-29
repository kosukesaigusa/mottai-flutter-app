import 'dart:async';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth.dart';
import '../firestore_repository.dart';
import '../user/host.dart';
import '../user/user_mode.dart';
import '../user/worker.dart';
import 'chat_room_state.dart';
import 'read_status.dart';

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

/// チャット相手の名前を取得する [Provider].
final chatPartnerDisplayNameProvider =
    Provider.family.autoDispose<String, ReadChatRoom>((ref, readChatRoom) {
  final userMode = ref.watch(userModeStateProvider);
  switch (userMode) {
    case UserMode.worker:
      return ref.watch(hostDisplayNameProvider(readChatRoom.hostId));
    case UserMode.host:
      return ref.watch(workerDisplayNameProvider(readChatRoom.workerId));
  }
});

final chatRoomStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChatRoomStateNotifier, ChatRoomState, String>(
  (ref, chatRoomId) => ChatRoomStateNotifier(
    chatRoomId: chatRoomId,
    // TODO: userId の null チェックを行っていないのは改善の余地あり。
    userId: ref.watch(userIdProvider)!,
    chatRoomRepository: ref.watch(chatRoomRepositoryProvider),
    chatMessageRepository: ref.watch(chatMessageRepositoryProvider),
    readStatusService: ref.watch(readStatusServiceProvider),
  ),
);

class ChatRoomStateNotifier extends StateNotifier<ChatRoomState> {
  ChatRoomStateNotifier({
    required String chatRoomId,
    required String userId,
    required ChatRoomRepository chatRoomRepository,
    required ChatMessageRepository chatMessageRepository,
    required ReadStatusService readStatusService,
  })  : _chatRoomId = chatRoomId,
        _userId = userId,
        _chatRoomRepository = chatRoomRepository,
        _chatMessageRepository = chatMessageRepository,
        _readStatusService = readStatusService,
        super(const ChatRoomState()) {
    _newReadChatMessagesSubscription = _chatMessageRepository
        .subscribeChatMessages(
          chatRoomId: _chatRoomId,
          startDateTime: _startDateTime,
        )
        .listen(_updateNewReadChatMessages);
    Future<void>(() async {
      await Future.wait<void>([
        _fetchChatRoom(),
        _updateReadStatus(),
        loadMore(),
        // NOTE: ChatPage に遷移直後のメッセージアイコンを意図的に見せるために最低でも 500 ms 待つ。
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

  /// [ChatRoomRepository] のインスタンス。
  final ChatRoomRepository _chatRoomRepository;

  /// [ChatMessageRepository] のインスタンス。
  final ChatMessageRepository _chatMessageRepository;

  /// [ReadStatusService] のインスタンス。
  final ReadStatusService _readStatusService;

  /// チャットルームの ID.
  final String _chatRoomId;

  /// サインイン中の userId.
  final String _userId;

  /// 無限スクロールで取得するメッセージ件数の limit 値。
  static const _limit = 10;

  /// この時刻以降のメッセージを新たなメッセージとしてリアルタイム取得する。
  final _startDateTime = DateTime.now();

  /// 新着メッセージの [StreamSubscription].
  /// リスナーで state.newReadChatMessages を更新する。
  late final StreamSubscription<List<ReadChatMessage>>
      _newReadChatMessagesSubscription;

  /// チャットルームを取得する。
  Future<void> _fetchChatRoom() async {
    final readChatRoom = await _chatRoomRepository.fetchChatRoom(
      chatRoomId: _chatRoomId,
    );
    state = state.copyWith(readChatRoom: readChatRoom);
  }

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

  /// チャットルーム画面に遷移した後に、新たにメッセージを取得したときに、
  /// `state.newReadChatMessages` を更新し、[_updateReadChatMessages] メソッドを
  /// コールして、取得したメッセージ全体を更新する。
  void _updateNewReadChatMessages(List<ReadChatMessage> newReadChatMessages) {
    state = state.copyWith(newReadChatMessages: newReadChatMessages);
    _updateReadChatMessages();
    _updateReadStatus();
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
        ...state.pastReadChatMessages,
      ],
    );
  }

  /// [ReadStatus] を更新する。
  Future<void> _updateReadStatus() => _readStatusService.setReadStatus(
        chatRoomId: _chatRoomId,
        userId: _userId,
      );

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

final startChatProvider = Provider.autoDispose<StartChat>(
  (ref) => StartChat(
    chatRoomRepository: ref.watch(chatRoomRepositoryProvider),
    chatMessageRepository: ref.watch(chatMessageRepositoryProvider),
  ),
);

class StartChat {
  StartChat({
    required ChatRoomRepository chatRoomRepository,
    required ChatMessageRepository chatMessageRepository,
  })  : _chatRoomRepository = chatRoomRepository,
        _chatMessageRepository = chatMessageRepository;

  final ChatRoomRepository _chatRoomRepository;

  final ChatMessageRepository _chatMessageRepository;

  /// 指定した [workerId], [hostId] との間のチャットルームを作成する。
  /// ワーカーからの最初のメッセージ [content] も送信する。
  /// 作成した [ChatRoom] の ID を返す。
  /// すでにそのホストとチャットルームを作成済みの場合は、例外をスローする。
  Future<String> invoke({
    required String workerId,
    required String hostId,
    required String content,
  }) async {
    // TODO: 本当はバッチ書き込みするのが望ましい
    final chatRoomId = await _chatRoomRepository.createChatRoom(
      workerId: workerId,
      hostId: hostId,
    );
    await _chatMessageRepository.addChatMessage(
      chatRoomId: chatRoomId,
      senderId: workerId,
      // メッセージを始めるのは常にワーカー。
      chatMessageType: ChatMessageType.worker,
      content: content,
    );
    return chatRoomId;
  }
}
