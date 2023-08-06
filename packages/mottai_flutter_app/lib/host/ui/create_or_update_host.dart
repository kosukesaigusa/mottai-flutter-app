import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ホストページ。
@RoutePage()
class CreateOrUpdateHostPage extends ConsumerWidget {
  const CreateOrUpdateHostPage({
    @PathParam('userId') required this.userId,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/host/:userId';

  /// [CreateOrUpdateHostPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String userId}) => '/host/$userId';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホスト情報を入力'),
      ),
      body: const Text('ホストとして登録ページ'),
    );
  }
}
