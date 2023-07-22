import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

final workerServiceProvider = Provider.autoDispose<WorkerService>(
  (ref) => WorkerService(
    workerRepository: ref.watch(workerRepositoryProvider),
  ),
);

class WorkerService {
  const WorkerService({required WorkerRepository workerRepository})
      : _workerRepository = workerRepository;

  final WorkerRepository _workerRepository;

  /// 指定した [Worker] を取得する。
  Future<ReadWorker?> fetchWorker({required String workerId}) =>
      _workerRepository.fetchWorker(workerId: workerId);

  /// 指定した [Worker] が存在するかどうかを返す。
  Future<bool> workerExists({required String workerId}) async {
    final worker = await _workerRepository.fetchWorker(workerId: workerId);
    return worker != null;
  }

  /// [Worker] を作成する。
  Future<void> createWorker({
    required String workerId,
    required String displayName,
    String imageUrl = '',
    bool isHost = false,
  }) =>
      _workerRepository.setWorker(
        workerId: workerId,
        displayName: displayName,
        imageUrl: imageUrl,
        isHost: isHost,
      );
}
