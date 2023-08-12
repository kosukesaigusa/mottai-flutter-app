import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// [Job] の情報を更新する。
  Future<void> update({
    required String jobId,
    String? title,
    String? content,
    String? place,
    Set<AccessType>? accessTypes,
    String? accessDescription,
    String? belongings,
    String? reward,
    String? comment,
    String? imageUrl,
  }) =>
      _query.update(
        jobId: jobId,
        updateJob: UpdateJob(
          title: title,
          content: content,
          place: place,
          accessTypes: accessTypes,
          accessDescription: accessDescription,
          belongings: belongings,
          reward: reward,
          comment: comment,
          imageUrl: imageUrl,
        ),
      );
}
