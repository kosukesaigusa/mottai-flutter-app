import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../chat/chat_room.dart';
import '../../scaffold_messenger_controller.dart';

final startChatControllerProvider = Provider.autoDispose<StartChatController>(
  (ref) => StartChatController(
    startChat: ref.watch(startChatProvider),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class StartChatController {
  StartChatController({
    required StartChat startChat,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _startChat = startChat,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final StartChat _startChat;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 指定した [workerId], [hostId] との間のチャットルームを作成する。
  /// ワーカーからの最初のメッセージ [content] も送信する。
  /// 作成したチャットルームの ID を返す。
  Future<String?> startChatWithHost({
    required String workerId,
    required String hostId,
    required String content,
  }) async {
    if (content.isEmpty) {
      _appScaffoldMessengerController.showSnackBar('メッセージを入力してください');
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
      _appScaffoldMessengerController.showSnackBarByFirebaseException(e);
    }
    return null;
  }
}
