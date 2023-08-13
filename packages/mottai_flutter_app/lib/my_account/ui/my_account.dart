import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// マイアカウントページ。中身は Worker や Host の詳細画面を構成するウィジェットを使用する。
@RoutePage()
class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'myAccount';

  /// [MyAccountPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
