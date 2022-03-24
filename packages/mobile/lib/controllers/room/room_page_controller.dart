import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/room/room_page_state.dart';
import 'package:mottai_flutter_app/controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:mottai_flutter_app/providers/auth/auth_providers.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../utils/utils.dart';

final roomPageController = StateNotifierProvider.autoDispose
    .family<RoomPageController, RoomPageState, String>((ref, roomId) {
  return RoomPageController(ref.read, roomId);
});

class RoomPageController extends StateNotifier<RoomPageState> with LocatorMixin {
  RoomPageController(this._read, this._roomId) : super(const RoomPageState());
  TextEditingController textEditingController = TextEditingController();
  final Reader _read;
  final String _roomId;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  /// ルームに必要なものをイニシャライズする
  Future<void> initialize() async {
    // SharedPreferences を確認して下書きメッセージを取得するなどする
    state = state.copyWith(loading: false);
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
      _read(scaffoldMessengerController).unFocus();
      state = state.copyWith(sending: false);
      textEditingController.clear();
    }
  }

  /// 下書きを SharedPreferences に保存する
  Future<void> saveDraftMessage() async {}
}
