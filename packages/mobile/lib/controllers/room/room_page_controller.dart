import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/providers.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/utils.dart';
import '../scaffold_messenger/scaffold_messenger_controller.dart';
import 'room_page_state.dart';

final roomPageController = StateNotifierProvider.autoDispose
    .family<RoomPageController, RoomPageState, String>((ref, roomId) {
  return RoomPageController(ref.read, roomId)..init();
});

class RoomPageController extends StateNotifier<RoomPageState> {
  RoomPageController(this._read, this._roomId) : super(const RoomPageState());
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  final Reader _read;
  final String _roomId;

  /// このクラスをインスタンス化する際にコールする。
  /// Wantedly アプリを参考に、あえていくらか画面を表示するまでに待たせる。
  Future<void> init() async {
    await Future.wait<void>([
      _initialize(),
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);
    state = state.copyWith(loading: false);
  }

  /// ルームに必要な初期化処理を行う。
  Future<void> _initialize() async {
    await _initializeTextEditingController();
    _initializeScrollController();
    final userId = _read(userIdProvider).value;
    if (userId != null) {
      // 非同期的に lastReadAt を更新する
      unawaited(MessageRepository.readStatusRef(
        roomId: _roomId,
        readStatusId: userId,
      ).set(const ReadStatus(), SetOptions(merge: true)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    Future<void>(() async {
      await _setDraftMessageFromSharedPreferences();
      textEditingController.dispose();
      scrollController.dispose();
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

  /// ScrollController を初期化してリスナーを設定する
  void _initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      final currentPosition = scrollController.position.pixels;
      // スクロール位置の終端（チャットは画面上端が終端）から 20 ピクセルの位置に達したら
      // 次のメッセージを読み込む
      if (maxScrollExtent > 0 && (maxScrollExtent - 20.0) <= currentPosition) {
        final a = state.lastVisibleQds;
        print('スクロールのしきい値超えた: ${a?.id ?? ''}');
        // _read(lastVisibleMessageQdsProvider.notifier).update((state) => a);
      }
    });
  }

  List<Message> updateLastVisibleQds({
    required List<Message> messages,
    required QueryDocumentSnapshot<Message>? qds,
  }) {
    state = state.copyWith(
      messages: [...state.messages, ...messages],
      lastVisibleQds: qds,
    );
    return state.messages;
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
}
