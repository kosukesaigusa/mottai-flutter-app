import '../firestore_documents/job.dart';

class JobRepository {
  final _query = JobQuery();

  /// 指定した [Job] を取得する。
  Future<ReadJob?> fetchJob({required String jobId}) =>
      _query.fetchDocument(jobId: jobId);
}
