import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/_export.dart';

class ReviewRepository {
  final _query = ReviewQuery();

  /// [fetchReviewsWithIdCursor] メソッドにおいて、最後に読み込んだ
  /// [QueryDocumentSnapshot] を保持するための [Map] 型の変数。
  /// キーはそのドキュメント ID で、バリューが [QueryDocumentSnapshot].
  final Map<String, QueryDocumentSnapshot<ReadReview>>
      _lastFetchedQueryDocumentSnapshotCache = {};

  /// まず [_lastFetchedQueryDocumentSnapshotCache] をクリアして、非 null の場合は、
  /// 新しい [lastFetchedQueryDocumentSnapshot] をキャッシュに入れる。
  void _updateLastReadQueryDocumentSnapshotCache(
    QueryDocumentSnapshot<ReadReview>? lastFetchedQueryDocumentSnapshot,
  ) {
    _lastFetchedQueryDocumentSnapshotCache.clear();
    if (lastFetchedQueryDocumentSnapshot != null) {
      _lastFetchedQueryDocumentSnapshotCache[lastFetchedQueryDocumentSnapshot
          .id] = lastFetchedQueryDocumentSnapshot;
    }
  }

  /// [Review] を [limit] 件取得する。[lastFetchedId] が指定されている場合は、
  /// そのドキュメント以降のドキュメントが得られる。
  Future<List<ReadReview>> fetchReviewsWithIdCursor({
    required int limit,
    required String? lastFetchedId,
  }) async {
    var query = readReviewCollectionReference.orderBy(
      'createdAt',
      descending: true,
    );
    final qds = lastFetchedId == null
        ? null
        : _lastFetchedQueryDocumentSnapshotCache[lastFetchedId];
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    final qs = await query.limit(limit).get();
    final reviews = qs.docs.map((qds) => qds.data()).toList();
    final lastFetchedQds = qs.docs.lastOrNull;
    _updateLastReadQueryDocumentSnapshotCache(lastFetchedQds);
    return reviews;
  }

  /// 指定した [workerId] の投稿した [Review] 一覧を購読する。
  Stream<List<ReadReview>> subscribeUserReviews({required String workerId}) {
    return _query.subscribeDocuments(
      queryBuilder: (query) => query
          .where('workerId', isEqualTo: workerId)
          .orderBy('createdAt', descending: true),
    );
  }

  /// 指定した [Review] を取得する。
  Future<ReadReview?> fetchReview({required String reviewId}) =>
      _query.fetchDocument(reviewId: reviewId);

  /// [Review] を作成する。
  Future<void> create({
    required String workerId,
    required String jobId,
    required String imageUrl,
    required String title,
    required String content,
  }) =>
      _query.add(
        createReview: CreateReview(
          workerId: workerId,
          jobId: jobId,
          title: title,
          content: content,
          imageUrl: imageUrl,
        ),
      );

  /// [Review] を更新する。
  Future<void> update({
    required String reviewId,
    String? title,
    String? content,
    String? imageUrl,
  }) =>
      _query.update(
        reviewId: reviewId,
        updateReview: UpdateReview(
          title: title,
          content: content,
          imageUrl: imageUrl,
        ),
      );
}
