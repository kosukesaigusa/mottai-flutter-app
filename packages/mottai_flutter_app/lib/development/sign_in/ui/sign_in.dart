import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/sign_in_buttons.dart';

@RoutePage()
class SignInSamplePage extends ConsumerWidget {
  const SignInSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/signInSample';

  /// [SignInSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サインインページ'),
      ),
      body: const Center(
        child: SignInButtons(),
      ),
    );
  }
}
