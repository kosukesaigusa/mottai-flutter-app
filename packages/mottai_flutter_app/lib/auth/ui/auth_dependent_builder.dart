import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth.dart';

/// Firebase に Auth にサインイン済みの場合にのみ [onAuthenticated] で渡した
/// ウィジェットを表示する。
/// その際、サインイン済みのユーザーの `userId` が使用できる。
class AuthDependentBuilder extends ConsumerWidget {
  const AuthDependentBuilder({
    super.key,
    required this.onAuthenticated,
    this.onUnAuthenticated,
  });

  /// Firebase に Auth にサインイン済みの場合に表示されるウィジェットを `userId` とともに
  /// 返すビルダー関数。
  final Widget Function(String userId) onAuthenticated;

  ///  Firebase Auth にサインインしていない場合に表示されるウィジェットを返すビルダー関数（任意）。
  /// 渡さなければ共通の [_SignedOut] ウィジェットが表示される。
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

/// Firebase Auth にサインイン済みであり、そのユーザーが指定した [userId] に一致する場合
/// にのみ [onUserAuthenticated] で渡したウィジェットを表示する。
/// その際、サインイン済みのユーザーの [userId] が使用できる。
class UserAuthDependentBuilder extends ConsumerWidget {
  const UserAuthDependentBuilder({
    super.key,
    required this.userId,
    required this.onUserAuthenticated,
    this.onUserUnAuthenticated,
  });

  /// Firebase Auth にサインイン済みであり、そのユーザーが指定した [userId] に一致する場合
  /// に表示されるウィジェットを [userId] とともに返すビルダー関数。
  final Widget Function(String userId) onUserAuthenticated;

  /// Firebase Auth にサインインしていない、またはサインイン済みでもそのユーザーが指定した
  /// [userId] に一致しない場合表示されるウィジェットを返すビルダー関数（任意）。
  final Widget Function()? onUserUnAuthenticated;

  /// 表示するユーザーの uid.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null || userId != this.userId) {
      if (onUserUnAuthenticated != null) {
        return onUserUnAuthenticated!();
      } else {
        return const SizedBox();
      }
    }
    return onUserAuthenticated(userId);
  }
}
