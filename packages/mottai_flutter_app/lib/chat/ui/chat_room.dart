import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../color.dart';
import '../../error/ui/error.dart';
import '../../user/user_mode.dart';
import '../chat_room.dart';
import '../read_status.dart';

/// このファイルの複数箇所で指定している水平方向の Padding。
const double _horizontalPadding = 8;

/// このファイルの複数箇所で指定しているメッセージ送信者のアイコンサイズ。
const double _senderIconSize = 24;

/// チャットルームページ。
@RoutePage()
class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({
    @PathParam('chatRoomId') required this.chatRoomId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/chatRooms/:chatRoomId';

  /// [ChatRoomPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String chatRoomId}) =>
      '/chatRooms/$chatRoomId';

  /// パスパラメータから得られるチャットルームの ID.
  final String chatRoomId;

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  late final ScrollController _scrollController;

  /// 画面の何割をスクロールした時点で次の _limit 件のメッセージを取得するか。
  static const _scrollValueThreshold = 0.8;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() async {
        final scrollValue = _scrollController.offset /
            _scrollController.position.maxScrollExtent;
        if (scrollValue > _scrollValueThreshold) {
          await ref
              .read(chatRoomStateNotifierProvider(widget.chatRoomId).notifier)
              .loadMore();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(() {})
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatRoomStateNotifierProvider(widget.chatRoomId));
    final loading = state.loading;
    final readChatRoom = state.readChatRoom;
    final partnerDisplayName = readChatRoom == null
        ? ''
        : ref.watch(chatPartnerDisplayNameProvider(readChatRoom));
    final userMode = ref.watch(userModeStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(partnerDisplayName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AuthDependentBuilder(
          onAuthenticated: (userId) {
            if (loading) {
              return const Center(
                child: Icon(
                  Icons.chat,
                  size: 80,
                  color: Colors.black12,
                ),
              );
            }
            if (readChatRoom == null) {
              return const Unavailable('チャットルームの情報の取得に失敗しました。');
            }
            if (!_hasAccessToChatRoom(
              userId: userId,
              userMode: userMode,
              readChatRoom: readChatRoom,
            )) {
              return const Unavailable('そのチャットルームは表示できません。');
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.readChatMessages.length,
                        reverse: true,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final readChatMessage = state.readChatMessages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _ChatMessageItem(
                              readChatRoom: readChatRoom,
                              readChatMessage: readChatMessage,
                              isMyMessage: readChatMessage.senderId == userId,
                              chatRoomId: widget.chatRoomId,
                            ),
                          );
                        },
                      ),
                    ),
                    _MessageTextField(
                      chatRoomId: widget.chatRoomId,
                      userId: userId,
                    ),
                    const Gap(24),
                  ],
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _DebugIndicator(
                      chatRoomId: widget.chatRoomId,
                      readChatRoom: readChatRoom,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// チャットルームにアクセスできるかどうかを返す。
  bool _hasAccessToChatRoom({
    required String userId,
    required UserMode userMode,
    required ReadChatRoom readChatRoom,
  }) {
    switch (userMode) {
      case UserMode.worker:
        return readChatRoom.workerId == userId;
      case UserMode.host:
        return readChatRoom.hostId == userId;
    }
  }
}

/// [ChatMessage] のひとつひとつの UI.
class _ChatMessageItem extends ConsumerWidget {
  const _ChatMessageItem({
    required this.readChatRoom,
    required this.readChatMessage,
    required this.isMyMessage,
    required this.chatRoomId,
  });

  final ReadChatRoom readChatRoom;

  final ReadChatMessage readChatMessage;

  final bool isMyMessage;

  final String chatRoomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerImageUrl =
        ref.watch(chatPartnerImageUrlProvider(readChatRoom));
    final partnerLastReadAt =
        ref.watch(chatPartnerLastReadAtProvider(readChatRoom));
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              if (partnerImageUrl.isEmpty)
                const Icon(
                  Icons.account_circle,
                  size: _senderIconSize * 2,
                )
              else
                GenericImage.circle(
                  imageUrl: partnerImageUrl,
                  size: _senderIconSize * 2,
                ),
              const Gap(_horizontalPadding),
            ],
            Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width -
                            _senderIconSize * 2 -
                            _horizontalPadding * 3) *
                        0.9,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(8),
                      topRight: const Radius.circular(8),
                      bottomLeft: Radius.circular(isMyMessage ? 8 : 0),
                    ),
                    color: isMyMessage
                        ? Theme.of(context).primaryColor
                        : backgroundGrey,
                  ),
                  child: SelectableText(
                    readChatMessage.content,
                    style: isMyMessage
                        ? Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white)
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (isMyMessage) ...[
                  const Gap(4),
                  _ReadStatusText(
                    messageCreatedAt: readChatMessage.createdAt,
                    partnerLastReadAt: partnerLastReadAt,
                  ),
                ],
                const Gap(4),
                _MessageCreatedAtText(
                  readChatMessage: readChatMessage,
                  isMyMessage: isMyMessage,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// '既読' or '未読' の文字列を表示する UI.
class _ReadStatusText extends StatelessWidget {
  const _ReadStatusText({
    required this.messageCreatedAt,
    required this.partnerLastReadAt,
  });

  final DateTime? messageCreatedAt;
  final DateTime? partnerLastReadAt;

  @override
  Widget build(BuildContext context) {
    final text = _readStatusString(
      messageCreatedAt: messageCreatedAt,
      partnerLastReadAt: partnerLastReadAt,
    );
    if (text.isEmpty) {
      return const SizedBox();
    }
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }

  /// メッセージの作成日時 ([messageCreatedAt]) とパートナーの最終既読時刻
  /// ([partnerLastReadAt]) とを比較して、'既読' or '未読' の文字列を返す。
  String _readStatusString({
    required DateTime? messageCreatedAt,
    required DateTime? partnerLastReadAt,
  }) {
    if (messageCreatedAt == null) {
      return '';
    }
    if (partnerLastReadAt == null) {
      return '未読';
    }
    return messageCreatedAt.isAfter(partnerLastReadAt) ? '未読' : '既読';
  }
}

/// メッセージの送信日時（現在時刻からの相対的な時刻）を表示する UI.
class _MessageCreatedAtText extends StatelessWidget {
  const _MessageCreatedAtText({
    required this.readChatMessage,
    required this.isMyMessage,
  });

  final ReadChatMessage readChatMessage;

  final bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    final createdAt = readChatMessage.createdAt;
    if (createdAt == null) {
      return const SizedBox();
    }
    return Text(
      createdAt.formatRelativeDate(),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

/// [ChatMessage] を送信するための [TextField] などの UI.
class _MessageTextField extends ConsumerStatefulWidget {
  const _MessageTextField({required this.chatRoomId, required this.userId});

  final String chatRoomId;

  final String userId;

  @override
  ConsumerState<_MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends ConsumerState<_MessageTextField> {
  late final TextEditingController _textEditingController;

  bool _isValid = false;

  @override
  void initState() {
    _textEditingController = TextEditingController()
      ..addListener(() {
        _isValid = _textEditingController.text.isNotEmpty;
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMode = ref.watch(userModeStateProvider);
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: backgroundGrey,
            ),
            child: TextField(
              controller: _textEditingController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 36,
                  top: 8,
                  bottom: 8,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'メッセージを入力',
                hintStyle: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (!_isValid) {
              return;
            }
            final content = _textEditingController.text;
            if (content.isEmpty) {
              return;
            }
            await ref
                .read(chatRoomStateNotifierProvider(widget.chatRoomId).notifier)
                .sendChatMessage(
                  senderId: widget.userId,
                  chatMessageType: _chatMessageType(userMode),
                  content: content,
                );
            _textEditingController.clear();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isValid
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
            ),
            child: const Icon(Icons.send, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// [UserMode] に応じて送信するメッセージの [ChatMessageType] を選択する。
  ChatMessageType _chatMessageType(UserMode userMode) {
    switch (userMode) {
      case UserMode.worker:
        return ChatMessageType.worker;
      case UserMode.host:
        return ChatMessageType.host;
    }
  }
}

// TODO: 後で消す
/// 開発時のみ表示する、無限スクロールのデバッグ用ウィジェット。
class _DebugIndicator extends ConsumerWidget {
  const _DebugIndicator({
    required this.chatRoomId,
    required this.readChatRoom,
  });

  final String chatRoomId;

  final ReadChatRoom readChatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatRoomStateNotifierProvider(chatRoomId));
    final readChatMessages = state.readChatMessages;
    final lastReadChatMessageId = state.lastReadChatMessageId;
    final partnerLastReadAt = ref.watch(
      chatPartnerLastReadAtProvider(
        readChatRoom,
      ),
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'デバッグウィンドウ',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
          const Gap(4),
          Text(
            '取得したメッセージ：${readChatMessages.length.withComma} 件',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          Text(
            '取得中？：${state.fetching}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          Text(
            'まだ取得できる？：${state.hasMore}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          if (lastReadChatMessageId != null)
            Text(
              '最後に取得したドキュメント ID：$lastReadChatMessageId',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          Text(
            'パートナーの既読時間：$partnerLastReadAt',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
