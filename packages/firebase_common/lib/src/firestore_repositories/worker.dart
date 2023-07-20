import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

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
  Future<void> set({
    required String workerId,
    required String displayName,
    String imageUrl = '',
    bool isHost = false,
    SealedTimestamp createdAt = const ServerTimestamp(),
    SealedTimestamp updatedAt = const ServerTimestamp(),
  }) =>
      _query.set(
        workerId: workerId,
        createWorker: CreateWorker(
          displayName: displayName,
          imageUrl: imageUrl,
          isHost: isHost,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
}
