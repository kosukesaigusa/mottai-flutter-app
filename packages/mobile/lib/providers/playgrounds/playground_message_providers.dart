import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../providers.dart';

/// 指定した roomId の messages サブコレクションを購読する StreamProvider
final playgroundMessagesStreamProvider = StreamProvider.autoDispose<List<PlaygroundMessage>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return PlaygroundMessageRepository.subscribePlaygroundMessages(
    queryBuilder: (q) => q.orderBy('createdAt', descending: true),
  );
});
