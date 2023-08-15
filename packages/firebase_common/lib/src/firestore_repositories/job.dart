import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// [Job] の情報を作成する。
  Future<void> create({
    required String hostId,
    required String title,
    required String content,
    required String place,
    required Set<AccessType> accessTypes,
    required String accessDescription,
    required String belongings,
    required String reward,
    required String comment,
    required String imageUrl,
  }) =>
      _query.add(
        createJob: CreateJob(
          hostId: hostId,
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
