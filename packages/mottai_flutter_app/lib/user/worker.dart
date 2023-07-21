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

  /// [Worker] を作成する。
  Future<void> create({
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
