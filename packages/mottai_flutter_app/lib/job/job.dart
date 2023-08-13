import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

/// 指定した [Job] を取得する [FutureProvider].
final jobFutureProvider = FutureProvider.family.autoDispose<ReadJob?, String>(
  (ref, jobId) => ref.watch(jobServiceProvider).fetchJob(jobId: jobId),
);

/// 指定したユーザーの [Job] を全件取得する [FutureProvider].
final userJobsFutureProvider =
    FutureProvider.family.autoDispose<List<ReadJob>, String>(
  (ref, userId) => ref.watch(jobServiceProvider).fetchUserJobs(userId: userId),
);

final jobServiceProvider = Provider.autoDispose<JobService>(
  (ref) => JobService(
    jobRepository: ref.watch(jobRepositoryProvider),
  ),
);

class JobService {
  const JobService({required JobRepository jobRepository})
      : _jobRepository = jobRepository;

  final JobRepository _jobRepository;

  /// 指定した [Job] を取得する。
  Future<ReadJob?> fetchJob({required String jobId}) =>
      _jobRepository.fetchJob(jobId: jobId);

  /// 指定したユーザーの [Job] を全件取得する。
  Future<List<ReadJob>> fetchUserJobs({required String userId}) =>
      _jobRepository.fetchUserJobs(userId: userId);

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
      _jobRepository.create(
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
      _jobRepository.update(
        jobId: jobId,
        title: title,
        content: content,
        place: place,
        accessTypes: accessTypes,
        accessDescription: accessDescription,
        belongings: belongings,
        reward: reward,
        comment: comment,
        imageUrl: imageUrl,
      );
}
