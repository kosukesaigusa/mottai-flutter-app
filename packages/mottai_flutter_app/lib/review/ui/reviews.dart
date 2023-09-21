import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../pagination/ui/pagination_list_view.dart';
import '../../user/worker.dart';
import '../review.dart';

/// レビュー一覧画面。
@RoutePage()
class ReviewsPage extends ConsumerWidget {
  const ReviewsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'reviews';

  /// [ReviewsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FirestorePaginationView<ReadReview>(
      stateNotifierProvider: reviewsStateNotifierProvider,
      whenData: (context, reviews) => ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return MaterialVerticalCard(
            headerImageUrl: ref.watch(workerImageUrlProvider(review.workerId)),
            header: ref.watch(workerDisplayNameProvider(review.workerId)),
            subhead: review.createdAt?.formatRelativeDate(),
            imageUrl: review.imageUrl,
            title: review.title,
            content: review.content,
            menuButtonOnPressed: () {},
            actions: [
              ElevatedButton(
                onPressed: () {
                  // TODO: 感想詳細ページへ遷移する
                },
                child: const Text('もっと見る'),
              ),
            ],
          );
        },
      ),
      whenEmpty: (_) => const SizedBox(),
    );
  }
}
