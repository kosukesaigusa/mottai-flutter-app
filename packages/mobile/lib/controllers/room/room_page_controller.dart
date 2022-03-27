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
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    await Future.wait<void>([
      _initialize(),
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);
    state = state.copyWith(loading: false);
  }

  /// ルームに必要な初期化処理を行う。
  Future<void> _initialize() async {
    _listenTextEditingController();
    textEditingController.text = await _getDraftMessageFromSharedPreferences();
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

  /// TextEditingController にリスナーを設定する
  void _listenTextEditingController() {
    textEditingController.addListener(() {
      final text = textEditingController.text;
      state = state.copyWith(isValid: text.isNotEmpty);
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
