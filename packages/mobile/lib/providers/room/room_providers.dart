import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../constants/room.dart';
import '../../controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/utils.dart';
import '../providers.dart';
import 'room_page_state.dart';

/// 指定した roomId の Room ドキュメントを購読する StreamProvider
final roomStreamProvider = StreamProvider.autoDispose.family<Room?, String>((ref, roomId) {
  return MessageRepository.subscribeRoom(roomId: roomId);
});

/// ルームページのメッセージを読み書きする状態管理・操作を担当する
///  StateNotifierProvider
final roomPageStateNotifierProvider =
    StateNotifierProvider.autoDispose.family<RoomPageStateNotifierProvider, RoomPageState, String>(
  (ref, roomId) {
    final userId = ref.watch(userIdProvider).value;
    if (userId == null) {
      throw const SignInRequiredException();
    }
    return RoomPageStateNotifierProvider(ref.read, roomId)..initialize();
  },
);

/// RoomPage の状態を管理・操作する StateNotifierProvider
class RoomPageStateNotifierProvider extends StateNotifier<RoomPageState> {
  RoomPageStateNotifierProvider(this._read, this._roomId) : super(const RoomPageState());

  final Reader _read;
  final String _roomId;
  late StreamSubscription<List<Message>> _newMessagesSubscription;
  late TextEditingController textEditingController;
  late ScrollController scrollController;

  @override
  void dispose() {
    Future<void>(() async {
      super.dispose();
      await _setDraftMessageFromSharedPreferences();
      await _newMessagesSubscription.cancel();
      textEditingController.dispose();
      scrollController.dispose();
    });
  }

  /// 初期化処理。
  /// コンストラクタメソッドと一緒にコールする。
  Future<void> initialize() async {
    _initializeScrollController();
    _initializeNewMessagesSubscription();
    await Future.wait<void>([
      _initializeTextEditingController(),
      loadMore(),
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);
    state = state.copyWith(loading: false);
  }

  /// 読み取り開始時刻以降のメッセージを購読して
  /// 画面に表示する messages に反映させるリスナーを初期化する。
  void _initializeNewMessagesSubscription() {
    _newMessagesSubscription = MessageRepository.subscribeMessages(
      roomId: _roomId,
      queryBuilder: (q) => q
          .orderBy('createdAt', descending: true)
          .where('createdAt', isGreaterThanOrEqualTo: DateTime.now()),
    ).listen((messages) async {
      state = state.copyWith(newMessages: messages);
      _updateMessages();
      // ルームを開いている間にメッセージが届いた場合は
      // すぐに既読になるように lastReadAt も更新する。
      final userId = _read(userIdProvider).value;
      if (userId != null) {
        await MessageRepository.readStatusRef(
          roomId: _roomId,
          readStatusId: userId,
        ).set(const ReadStatus(), SetOptions(merge: true));
      }
    });
  }

  /// TextEditingController を初期化してリスナーを設定する
  Future<void> _initializeTextEditingController() async {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      final text = textEditingController.text;
      state = state.copyWith(isValid: text.isNotEmpty);
    });
    // 以前の下書きが残っていれば予め入力しておく
    textEditingController.text = await _getDraftMessageFromSharedPreferences();
  }

  /// ListView の ScrollController を初期化して、
  /// 過去のメッセージを遡って取得するための Listener を設定する。
  void _initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      final scrollValue = scrollController.offset / scrollController.position.maxScrollExtent;
      if (scrollValue > scrollValueThreshold) {
        await loadMore();
      }
    });
  }

  /// SharedPreferences に roomId をキーとした下書きが存在すれば取得する
  Future<String> _getDraftMessageFromSharedPreferences() async {
    return SharedPreferencesService.getDraftMessage(_roomId);
  }

  /// SharedPreferences に roomId をキーとした下書きを保存する
  Future<void> _setDraftMessageFromSharedPreferences() async {
    await SharedPreferencesService.setDraftMessage(
      roomId: _roomId,
      message: textEditingController.value.text,
    );
  }

  /// 無限スクロールのクエリ
  Query<Message> get _query {
    var query =
        MessageRepository.messagesRef(roomId: _roomId).orderBy('createdAt', descending: true);
    final qds = state.lastVisibleQds;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    return query.limit(messageLimit);
  }

  /// 表示するメッセージを更新する
  void _updateMessages() {
    state = state.copyWith(messages: [...state.newMessages, ...state.pastMessages]);
  }

  /// メッセージを送信する
  Future<void> send() async {
    if (state.sending) {
      return;
    }
    final userId = _read(userIdProvider).value;
    if (userId == null) {
      _read(scaffoldMessengerController).showSnackBar('一度サインインしてから再度お試しください。');
      return;
    }
    state = state.copyWith(sending: true);
    final body = textEditingController.value.text;
    if (body.isEmpty) {
      _read(scaffoldMessengerController).showSnackBar('内容を入力してください。');
      return;
    }
    final message = Message(
      messageId: uuid,
      senderId: userId,
      body: body,
    );
    try {
      await MessageRepository.messageRef(
        roomId: _roomId,
        messageId: message.messageId,
      ).set(message);
    } on FirebaseException catch (e) {
      _read(scaffoldMessengerController).showSnackBarByFirebaseException(e);
    } finally {
      state = state.copyWith(sending: false);
      textEditingController.clear();
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
      await SharedPreferencesService.removeByStringKey(_roomId);
    }
  }

  /// 過去のメッセージを、最後に取得した queryDocumentSnapshot 以降の
  /// limit 件だけ取得する。
  Future<void> loadMore() async {
    if (!state.hasMore) {
      state = state.copyWith(fetching: false);
      return;
    }
    if (state.fetching) {
      return;
    }
    state = state.copyWith(fetching: true);
    final qs = await _query.limit(messageLimit).get();
    final messages = qs.docs.map((qds) => qds.data()).toList();
    state = state.copyWith(pastMessages: [...state.pastMessages, ...messages]);
    _updateMessages();
    state = state.copyWith(
      fetching: false,
      lastVisibleQds: qs.docs.isNotEmpty ? qs.docs.last : null,
      hasMore: qs.docs.length >= messageLimit,
    );
  }
}
