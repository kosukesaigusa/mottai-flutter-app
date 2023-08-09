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
}
