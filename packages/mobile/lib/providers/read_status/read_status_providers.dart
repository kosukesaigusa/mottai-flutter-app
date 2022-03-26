import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../providers.dart';

/// 指定した roomId の Room ドキュメントを購読する StreamProvider
final readStatusStreamProvider =
    StreamProvider.autoDispose.family<ReadStatus?, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return MessageRepository.subscribeReadStatus(roomId: roomId, readStatusId: userId);
});
