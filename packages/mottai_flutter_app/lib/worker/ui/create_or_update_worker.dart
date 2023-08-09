import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ワーカーページ。
@RoutePage()
class CreateOrUpdateWorkerPage extends ConsumerWidget {
  const CreateOrUpdateWorkerPage({
    @PathParam('userId') required this.userId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/worker/:userId/edit';

  /// [CreateOrUpdateWorkerPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String userId}) => '/worker/$userId/edit';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ワーカー情報を入力'),
      ),
      body: const Text('ワーカー情報編集ページ'),
    );
  }
}
