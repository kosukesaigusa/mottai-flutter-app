import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

/// 指定した roomId の Room ドキュメントを購読する StreamProvider
final roomStreamProvider = StreamProvider.autoDispose.family<Room?, String>((ref, roomId) {
  return MessageRepository.subscribeRoom(roomId: roomId);
});
