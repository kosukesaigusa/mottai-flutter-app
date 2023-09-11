import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import '../../../user_fcm_token/user_fcm_token.dart';

@RoutePage()
class UserFcmTokenPage extends ConsumerWidget {
  const UserFcmTokenPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/userFcmTokens';

  /// [UserFcmTokenPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserFcmToken 一覧表示ページ'),
      ),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          final userFcmTokens =
              ref.watch(userFcmTokensStreamProvider(userId)).valueOrNull ?? [];
          return ListView.builder(
            itemCount: userFcmTokens.length,
            itemBuilder: (context, index) {
              final userFcmToken = userFcmTokens[index];
              return ListTile(
                leading: const Icon(Icons.token),
                title: Text(userFcmToken.token),
                subtitle: Text(userFcmToken.deviceInfo),
              );
            },
          );
        },
      ),
    );
  }
}
