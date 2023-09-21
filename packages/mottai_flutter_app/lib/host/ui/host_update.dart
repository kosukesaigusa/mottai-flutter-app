import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../user/host.dart';
import 'host_form.dart';

/// 仕事情報更新ページ。
@RoutePage()
class HostUpdatePage extends ConsumerWidget {
  const HostUpdatePage({
    @PathParam('hostId') required this.hostId,
    super.key,
  });

  static const path = '/hosts/:hostId/update';

  /// [HostUpdatePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static String location({required String hostId}) => '/hosts/$hostId/update';

  final String hostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostAsyncValue = ref.watch(hostFutureProvider(hostId));
    final host = hostAsyncValue.valueOrNull;
    final isLoading = hostAsyncValue.isLoading;
    if (host == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ホスト情報編集')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Center(child: Text('ホストが存在しません。')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('ホスト情報編集')),
      body: UserAuthDependentBuilder(
        userId: hostId,
        onAuthenticated: (userId, isUserAuthenticated) {
          if (!isUserAuthenticated) {
            return const Center(child: Text('このホスト情報は編集できません。'));
          }
          return HostForm.update(hostId: userId, host: host);
        },
      ),
    );
  }
}
