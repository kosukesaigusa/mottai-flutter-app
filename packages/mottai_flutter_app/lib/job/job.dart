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

  /// 指定したユーザーの [Job] を全件取得する。
  Future<List<ReadJob>> fetchUserJobs({required String hostId}) =>
      _jobRepository.fetchUserJobs(hostId: hostId);

  /// 指定したユーザーの [Job] を全件購読する。
  Stream<List<ReadJob>> subscribeUserJobs({required String hostId}) =>
      _jobRepository.subscribeUserJobs(hostId: hostId);
}
