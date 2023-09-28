import '../firestore_documents/worker.dart';

class WorkerRepository {
  final _query = WorkerQuery();

  /// 指定した [Worker] を購読する。
  Stream<ReadWorker?> subscribeWorker({required String workerId}) =>
      _query.subscribeDocument(workerId: workerId);

  /// 指定した [Worker] を取得する。
  Future<ReadWorker?> fetchWorker({required String workerId}) =>
      _query.fetchDocument(workerId: workerId);

  /// [Worker] を作成する。
  Future<void> setWorker({
    required String workerId,
    required String displayName,
    String imageUrl = '',
    String introduction = '',
    bool isHost = false,
  }) =>
      _query.set(
        workerId: workerId,
        createWorker: CreateWorker(
          displayName: displayName,
          imageUrl: imageUrl,
          isHost: isHost,
          introduction: introduction,
        ),
      );
}
