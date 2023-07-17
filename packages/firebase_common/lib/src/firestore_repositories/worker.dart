import '../firestore_documents/worker.dart';

class WorkerRepository {
  final _query = WorkerQuery();

  /// 指定した [Worker] を購読する。
  Stream<ReadWorker?> subscribeWorker({required String workerId}) =>
      _query.subscribeDocument(workerId: workerId);
}
