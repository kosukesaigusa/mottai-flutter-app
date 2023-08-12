import '../firestore_documents/job.dart';

class JobRepository {
  final _query = JobQuery();

  /// 指定した [Job] を取得する。
  Future<ReadJob?> fetchJob({required String jobId}) =>
      _query.fetchDocument(jobId: jobId);

  /// 指定した [Job] を購読する。
  Stream<ReadJob?> subscribeJob({required String jobId}) =>
      _query.subscribeDocument(jobId: jobId);

  /// 指定した `hostId` の [Job] を全件取得する。
  Future<List<ReadJob>> fetchUserJobs({required String hostId}) =>
      _query.fetchDocuments(
        queryBuilder: (query) => query.where('hostId', isEqualTo: hostId),
      );

  /// 指定した `hostId` の [Job] を全件購読する。
  Stream<List<ReadJob>> subscribeUserJobs({required String hostId}) =>
      _query.subscribeDocuments(
        queryBuilder: (query) => query.where('hostId', isEqualTo: hostId),
      );
}
