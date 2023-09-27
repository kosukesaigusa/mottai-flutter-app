import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import '../../../review/review.dart';
import 'review_form.dart';

/// `Job` に紐づく `Review` (＝感想)の更新画面。
@RoutePage()
class ReviewUpdatePage extends ConsumerWidget {
  const ReviewUpdatePage({
    @PathParam('jobId') required this.jobId,
    @PathParam('reviewId') required this.reviewId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/jobs/:jobId/reviews/:reviewId/update';

  /// [ReviewUpdatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String jobId, required String reviewId}) =>
      '/jobs/$jobId/reviews/$reviewId/update';

  final String jobId;

  final String reviewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(reviewFutureProvider(reviewId));
    final review = asyncValue.valueOrNull;
    final isLoading = asyncValue.isLoading;
    if (review == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('感想を更新する')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Center(child: Text('感想が存在しません。')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('感想を更新する')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return ReviewForm.update(
            workerId: userId,
            jobId: jobId,
            review: review,
          );
        },
      ),
    );
  }
}
