import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../chat/chat_room.dart';

final startChatControllerProvider = Provider.autoDispose<StartChatController>(
  (ref) => StartChatController(
    startChat: ref.watch(startChatProvider),
    appUIFeedbackController: ref.watch(appUIFeedbackControllerProvider),
  ),
);

class StartChatController {
  StartChatController({
    required StartChat startChat,
    required AppUIFeedbackController appUIFeedbackController,
  })  : _startChat = startChat,
        _appUIFeedbackController = appUIFeedbackController;

  final StartChat _startChat;

  final AppUIFeedbackController _appUIFeedbackController;

  /// 指定した [workerId], [hostId] との間のチャットルームを作成する。
  /// ワーカーからの最初のメッセージ [content] も送信する。
  /// 作成したチャットルームの ID を返す。
  Future<String?> startChatWithHost({
    required String workerId,
    required String hostId,
    required String content,
  }) async {
    if (content.isEmpty) {
      _appUIFeedbackController.showSnackBar('メッセージを入力してください');
      return null;
    }
    try {
      final chatRoomId = await _startChat.invoke(
        workerId: workerId,
        hostId: hostId,
        content: content,
      );
      return chatRoomId;
    } on FirebaseException catch (e) {
      _appUIFeedbackController.showSnackBarByFirebaseException(e);
    }
    return null;
  }
}
