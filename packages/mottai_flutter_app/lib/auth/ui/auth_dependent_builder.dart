import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth.dart';
import 'sign_in_buttons.dart';

/// Firebase に Auth にサインイン済みの場合にのみ [onAuthenticated] で渡した
/// ウィジェットを表示する。
/// その際、サインイン済みのユーザーの `userId` が使用できる。
class AuthDependentBuilder extends ConsumerWidget {
  const AuthDependentBuilder({
    super.key,
    required this.onAuthenticated,
    this.onUnAuthenticated,
  });

  /// Firebase Auth にサインイン済みの場合に表示されるウィジェットを `userId` とともに
  /// 返すビルダー関数。
  final Widget Function(String userId) onAuthenticated;

  /// Firebase Auth にサインインしていない場合に表示されるウィジェットを返すビルダー関数（任意）。
  /// 渡さなければ共通の [SignedOut] ウィジェットが表示される。
  final Widget Function()? onUnAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      if (onUnAuthenticated != null) {
        return onUnAuthenticated!();
      } else {
        return const SignedOut();
      }
    }
    return onAuthenticated(userId);
  }
}

/// Firebase に Auth にサインイン済みの場合にのみ [onAuthenticated] で渡した
/// ウィジェットを表示する。
/// その際、サインイン済みのユーザーの `userId` が使用できる。また、それが指定した [userId]
/// と一致するかどうかを表す `isUserAuthenticated` が使用できる。
class UserAuthDependentBuilder extends ConsumerWidget {
  const UserAuthDependentBuilder({
    super.key,
    required this.userId,
    required this.onAuthenticated,
    this.onUnAuthenticated,
  });

  /// Firebase Auth にサインイン済みであり、そのユーザーが指定した [userId] に一致する場合
  /// に表示されるウィジェットを [userId] および、それが [userId] と一致するかどうかを表す
  /// `isUserAuthenticated` とともに返すビルダー関数。
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(String userId, bool isUserAuthenticated)
      onAuthenticated;

  ///  Firebase Auth にサインインしていない場合に表示されるウィジェットを返すビルダー関数（任意）。
  /// 渡さなければ共通の [SignedOut] ウィジェットが表示される。
  final Widget Function()? onUnAuthenticated;

  /// 表示するユーザーの uid.
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      if (onUnAuthenticated != null) {
        return onUnAuthenticated!();
      } else {
        return const SignedOut();
      }
    }
    return onAuthenticated(userId, userId == this.userId);
  }
}
