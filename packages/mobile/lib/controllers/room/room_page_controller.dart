import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/room/room_page_state.dart';
import 'package:mottai_flutter_app/controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:mottai_flutter_app/providers/auth/auth_providers.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../utils/utils.dart';

class RoomPageController extends StateNotifier<RoomPageState> with LocatorMixin {
  RoomPageController(this._read) : super(const RoomPageState());
  TextEditingController textEditingController = TextEditingController();
  final Reader _read;

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
    final userId = _read(userIdProvider).value;
    if (userId == null) {
      return;
    }
    state = state.copyWith(sending: true);
    final body = textEditingController.value.text;
    if (body.isEmpty) {
      return;
    }
    final message = Message(
      messageId: uuid,
      senderId: userId,
      body: body,
    );
    try {
      // await MessageRepository.messageRef(roomId: roomId, messageId: message.messageId).set(message);
    } on FirebaseException catch (e) {
      _read(scaffoldMessengerController).showSnackBarByFirebaseException(e);
    } finally {
      state = state.copyWith(sending: false);
      textEditingController.clear();
    }
  }

  /// 下書きを SharedPreferences に保存する
  Future<void> saveDraftMessage() async {}
}
