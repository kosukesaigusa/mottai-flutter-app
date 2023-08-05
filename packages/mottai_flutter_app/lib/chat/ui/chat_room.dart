import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({super.key});

  static const path = '/chatRooms/:chatRoomId';
  static const name = 'ChatRoomPage';
  static String location({required String chatRoomId}) =>
      '/chatRooms/$chatRoomId';

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
          await ref.read(chatRoomStateNotifierProvider.notifier).loadMore();
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
    // TODO: パスパラメータから渡せるようにする
    const chatRoomId = 'aSNYpkUofu05nyasvMRx';
    final readChatRoom = ref.watch(chatRoomFutureProvider(chatRoomId)).value;
    if (readChatRoom == null) {
      // TODO: この実装だと、loading 中に UnavailablePage がちらっと見えそうなので改善したい。
      return const UnavailablePage('チャットルームの情報の取得に失敗しました。');
    }
    final state = ref.watch(chatRoomStateNotifierProvider);
    final partnerDisplayName =
        ref.watch(chatPartnerDisplayNameProvider(readChatRoom));
    return Scaffold(
      appBar: AppBar(
        // TODO: chatPartnerImageUrlProvider を真似して、chatPartnerNameProvider
        // を定義して（それに必要な workerNameProvider, hostNameProvider）、
        // AppBart のタイトルを適切なパートナ名にする。
        title: Text(partnerDisplayName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AuthDependentBuilder(
          onAuthenticated: (userId) => state.loading
              ? const Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidComment,
                    size: 72,
                    color: Colors.black12,
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.readChatMessages.length,
                            reverse: true,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final readChatMessage =
                                  state.readChatMessages[index];
                              return _ChatMessageItem(
                                readChatRoom: readChatRoom,
                                readChatMessage: readChatMessage,
                                isMyMessage: readChatMessage.senderId == userId,
                                chatRoomId: chatRoomId,
                              );
                            },
                          ),
                        ),
                        _MessageTextField(
                          chatRoomId: chatRoomId,
                          userId: userId,
                        ),
                        const Gap(24),
                      ],
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _DebugIndicator(
                          chatRoomId: chatRoomId,
                          readChatRoom: readChatRoom,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
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
    final partnerDisplayName =
        ref.watch(chatPartnerDisplayNameProvider(readChatRoom));
    return Column(
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              const Gap(8),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMyMessage) ...[
                  Text(partnerDisplayName),
                  if (partnerImageUrl.isEmpty)
                    const Icon(
                      Icons.account_circle,
                      size: _senderIconSize * 2,
                    )
                  else
                    // TODO: 汎用的な画像ウィジェットができたら丸形に差し替える
                    GenericImage.circle(
                      imageUrl: partnerImageUrl,
                      size: _senderIconSize * 2,
                    ),
                ],
                Container(
                  constraints: BoxConstraints(
                    // TODO: 計算する
                    maxWidth: (MediaQuery.of(context).size.width -
                            _senderIconSize -
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
                  child: Text(
                    readChatMessage.content,
                    style: isMyMessage
                        ? Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white)
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4,
            left: isMyMessage ? 0 : _senderIconSize + _horizontalPadding,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment:
                isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (readChatMessage.createdAt.dateTime != null)
                Text(
                  readChatMessage.createdAt.dateTime!.formatDate(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ],
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
                .read(chatRoomStateNotifierProvider.notifier)
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
    final state = ref.watch(chatRoomStateNotifierProvider);
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
