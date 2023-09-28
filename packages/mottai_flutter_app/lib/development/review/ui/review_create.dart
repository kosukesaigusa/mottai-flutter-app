import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import 'review_form.dart';

/// `Job` に紐づく `Review` (＝感想)の投稿画面。
@RoutePage()
class ReviewCreatePage extends ConsumerWidget {
  const ReviewCreatePage({
    @PathParam('jobId') required this.jobId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/jobs/:jobId/reviews/create';

  /// [ReviewCreatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String jobId}) =>
      '/jobs/$jobId/reviews/create';

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('感想を投稿する')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return ReviewForm.create(
            workerId: userId,
            jobId: jobId,
          );
        },
      ),
    );
  }
}
