import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth.dart';

/// Firebase に Auth にサインイン済みの場合にのみ [onAuthenticated] で渡した
/// ウィジェットを表示する。
/// その最、サインイン済みのユーザーの `userId` が使用できる。
class AuthDependentBuilder extends ConsumerWidget {
  const AuthDependentBuilder({
    super.key,
    required this.onAuthenticated,
    this.onUnAuthenticated,
  });

  /// サインイン済みの場合に表示されるウィジェットを `userId` とともに返す
  /// ビルダー関数。
  final Widget Function(String userId) onAuthenticated;

  final Widget Function()? onUnAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      if (onUnAuthenticated != null) {
        return onUnAuthenticated!();
      } else {
        return const _SignedOut();
      }
    }
    return onAuthenticated(userId);
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('ログインしてください。'));
  }
}
