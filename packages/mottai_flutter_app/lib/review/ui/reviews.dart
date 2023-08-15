import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// レビュー一覧画面。
@RoutePage()
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'reviews';

  /// [ReviewsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
