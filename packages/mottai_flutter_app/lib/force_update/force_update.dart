import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

final forceUpdateFutureProvider =
    StreamProvider.autoDispose<List<ReadForceUpdateConfig>>((ref) {
  final repository = ref.watch(forceUpdateConfigRepositoryProvider);
  return repository.subscribeForceUpdateConfig();
});
