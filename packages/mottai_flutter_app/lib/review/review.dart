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
