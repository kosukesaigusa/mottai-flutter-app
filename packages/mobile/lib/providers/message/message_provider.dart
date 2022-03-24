import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth_providers.dart';

/// 指定した roomId の messages サブコレクションを購読する StreamProvider
final messagesStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return MessageRepository.subscribeMessages(
    roomId: roomId,
    queryBuilder: (q) => q.orderBy('createdAt', descending: true),
  );
});
