import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import 'review_form.dart';

/// レビュー一覧画面。
@RoutePage()
class ReviewCreatePage extends ConsumerWidget {
  const ReviewCreatePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/postReview';

  /// [ReviewCreatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('感想を投稿する')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return ReviewForm.create(workerId: userId);
        },
      ),
    );
  }
}
