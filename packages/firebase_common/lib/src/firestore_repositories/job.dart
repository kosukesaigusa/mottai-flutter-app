import '../firestore_documents/job.dart';

class JobRepository {
  final _query = JobQuery();

  /// 指定した [Job] を取得する。
  Future<ReadJob?> fetchJob({required String jobId}) =>
      _query.fetchDocument(jobId: jobId);

  /// 指定したユーザーの [Job] を全件取得する。
  Future<List<ReadJob>> fetchUserJobs({required String userId}) =>
      _query.fetchDocuments(
        queryBuilder: (query) => query.where('hostId', isEqualTo: userId),
      );
}
