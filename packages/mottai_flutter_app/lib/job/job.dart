import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

/// 指定した [Job] を取得する [FutureProvider].
final jobFutureProvider = FutureProvider.family.autoDispose<ReadJob?, String>(
  (ref, jobId) => ref.watch(jobServiceProvider).fetchJob(jobId: jobId),
);

/// 指定した [Job] を購読する [StreamProvider].
final jobStreamProvider = StreamProvider.family.autoDispose<ReadJob?, String>(
  (ref, jobId) => ref.watch(jobServiceProvider).subscribeJob(jobId: jobId),
);

/// 指定した `hostId` に紐づく [Job] を全件取得する [FutureProvider].
final userJobsFutureProvider =
    FutureProvider.family.autoDispose<List<ReadJob>, String>(
  (ref, hostId) => ref.watch(jobServiceProvider).fetchUserJobs(hostId: hostId),
);

/// 指定した `hostId` に紐づく [Job] を全件購読する [StreamProvider].
final userJobsStreamProvider =
    StreamProvider.family.autoDispose<List<ReadJob>, String>(
  (ref, hostId) =>
      ref.watch(jobServiceProvider).subscribeUserJobs(hostId: hostId),
);

/// 指定した `hostId` に紐づく [Job] 一覧のうち、はじめの要素を取得する [Provider].
/// 最初のリリースでは [Job] は 1 件しか登録できないため、このような実装になっている。
final hostFirstJobFutureProvider =
    Provider.family.autoDispose<ReadJob?, String>(
  (ref, hostId) =>
      (ref.watch(userJobsStreamProvider(hostId)).valueOrNull ?? []).firstOrNull,
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

  /// 指定した [Job] を購読する。
  Stream<ReadJob?> subscribeJob({required String jobId}) =>
      _jobRepository.subscribeJob(jobId: jobId);

  /// 指定したユーザーの [Job] を全件取得する。
  Future<List<ReadJob>> fetchUserJobs({required String hostId}) =>
      _jobRepository.fetchUserJobs(hostId: hostId);

  /// 指定したユーザーの [Job] を全件購読する。
  Stream<List<ReadJob>> subscribeUserJobs({required String hostId}) =>
      _jobRepository.subscribeUserJobs(hostId: hostId);
}
