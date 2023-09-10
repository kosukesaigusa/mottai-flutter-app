import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth.dart';
import '../firestore_repository.dart';
import 'user_mode.dart';

/// サインイン中のユーザーの [Worker] ドキュメントを購読する [StreamProvider].
final currentUserWorkerStreamProvider =
    StreamProvider.autoDispose<ReadWorker?>((ref) {
  ref.watch(userModeStateProvider);
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.watch(workerRepositoryProvider).subscribeWorker(workerId: userId);
});

/// サインイン中のユーザーがホストかどうか判定する [Provider].
final isCurrentUserHostProvider = Provider.autoDispose<bool>(
  (ref) =>
      ref.watch(currentUserWorkerStreamProvider).valueOrNull?.isHost ?? false,
);

/// サインイン中のユーザーがホストであるとき、対応する [Host] ドキュメントを購読
/// する [StreamProvider].
final currentUserHostStreamProvider =
    StreamProvider.autoDispose<ReadHost?>((ref) {
  ref.watch(userModeStateProvider);
  final userId = ref.watch(userIdProvider);
  final isHost = ref.watch(isCurrentUserHostProvider);
  if (userId == null || !isHost) {
    return Stream.value(null);
  }
  return ref.watch(hostRepositoryProvider).subscribeHost(hostId: userId);
});

/// サインイン中のユーザーに対応するホストドキュメントが存在するかどうか判定する
/// `Future<bool> Function()` 型の関数を提供する [Provider].
final hostDocumentExistsProvider =
    Provider.autoDispose<Future<bool> Function()>(
  (ref) => () async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return false;
    }
    final host =
        await ref.read(hostRepositoryProvider).fetchHost(hostId: userId);
    return host != null;
  },
);
