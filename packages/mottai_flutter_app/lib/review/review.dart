import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../pagination/firestore_pagination.dart';

const _limit = 10;

/// [Review] を [_limit] 件ずつパジネーションで取得する [StateNotifierProvider].
final reviewsStateNotifierProvider = StateNotifierProvider.autoDispose<
    FirestorePaginationStateNotifier<ReadReview>, AsyncValue<List<ReadReview>>>(
  (ref) => FirestorePaginationStateNotifier<ReadReview>(
    fetch: (perPage, lastFetchedId) =>
        ref.watch(reviewRepositoryProvider).fetchReviewsWithIdCursor(
              limit: _limit,
              lastFetchedId: lastFetchedId,
            ),
    idFromObject: (obj) => obj.reviewId,
  ),
);

/// 指定した `workerId` の [Review] 一覧を購読する [StreamProvider].
final workerReviewsStreamProvider =
    StreamProvider.family.autoDispose<List<ReadReview>, String>(
  (ref, workerId) => ref
      .read(reviewRepositoryProvider)
      .subscribeUserReviews(workerId: workerId),
);

final reviewServiceProvider = Provider.autoDispose<ReviewService>(
  (ref) => ReviewService(
    reviewRepository: ref.watch(reviewRepositoryProvider),
  ),
);

class ReviewService {
  const ReviewService({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  final ReviewRepository _reviewRepository;

  /// [Review] の情報を作成する。
  Future<void> create({
    required String workerId,
    required String jobId,
    required String title,
    required String content,
    required String imageUrl,
  }) =>
      _reviewRepository.create(
        workerId: workerId,
        jobId: jobId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );

  /// [Review] の情報を更新する。
  Future<void> update({
    required String reviewId,
    String? title,
    String? content,
    String? imageUrl,
  }) =>
      _reviewRepository.update(
        reviewId: reviewId,
        title: title,
        content: content,
        imageUrl: imageUrl,
      );
}
