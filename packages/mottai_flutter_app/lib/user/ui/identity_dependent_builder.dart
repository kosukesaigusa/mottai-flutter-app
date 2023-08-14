import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';

/// サインイン済みのユーザーの userId と
/// 表示するユーザー情報の userIdが一致するかどうかで
/// ウィジェットの出し分けを行う
class IdentityDependentBuilder extends ConsumerWidget {
  const IdentityDependentBuilder({
    super.key,
    required this.buildForIdentity,
    this.buildForOthers,
    required this.targetUserId,
  });

  /// userIdが一致する場合に表示されるウィジェット
  /// ビルダー関数。
  final Widget Function() buildForIdentity;

  /// userIdが不一致の場合に表示されるウィジェット
  /// /// 渡さなければ [SizedBox] ウィジェットが表示される。
  final Widget Function()? buildForOthers;

  /// 表示するユーザーの userId
  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    if (userId == targetUserId) {
      return buildForIdentity();
    }
    if (buildForOthers != null) {
      return buildForOthers!();
    }
    return const SizedBox();
  }
}
