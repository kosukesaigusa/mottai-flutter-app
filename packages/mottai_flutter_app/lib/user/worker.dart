import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

/// 指定した [Worker] ドキュメントを購読する [StreamProvider].
final workerStreamProvider =
    StreamProvider.family.autoDispose<ReadWorker?, String>(
  (ref, workerId) =>
      ref.watch(workerRepositoryProvider).subscribeWorker(workerId: workerId),
);

/// 指定した [Worker] の画像 URL を返す [Provider].
/// 画像が存在しない場合や読み込み中・エラーの場合でも空文字を返す。
final workerImageUrlProvider =
    Provider.family.autoDispose<String, String>((ref, workerId) {
  final worker = ref.watch(workerStreamProvider(workerId)).valueOrNull;
  return worker?.imageUrl ?? '';
});
