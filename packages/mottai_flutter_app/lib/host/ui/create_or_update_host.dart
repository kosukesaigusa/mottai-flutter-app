import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ホスト情報を作成するか更新するかのタイプ
enum ActionType {
  /// ホスト情報を新規に作成する
  create,

  /// ホスト情報を更新する
  update
}

/// ホストページ。
@RoutePage()
class CreateOrUpdateHostPage extends ConsumerWidget {
  const CreateOrUpdateHostPage({
    @PathParam('userId') required this.userId,
    @PathParam('actionType') required this.actionType,
    super.key,
  });

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/host/:userId/:actionType';

  /// [CreateOrUpdateHostPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({
    required String userId,
    required String actionType,
  }) =>
      '/host/$userId/$actionType';

  /// パスパラメータから得られるユーザーの ID.
  final String userId;

  /// パスパラメータから得られるホスト情報を【作成】するか【更新】するかの タイプ.
  final String actionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホスト情報を入力'),
      ),
      body: Column(
        children: [
          const Text('ホスト情報の作成または更新ページ'),
          Text('このページは【$actionType】タイプで表示されています')
        ],
      ),
    );
  }
}
