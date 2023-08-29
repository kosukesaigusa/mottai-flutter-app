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
    return Scaffold(
      appBar: AppBar(title: const Text('お手伝い募集内容を入力')),
      body: AuthDependentBuilder(
        onAuthenticated: (hostId) {
          return ref.watch(hostFutureProvider(hostId)).when(
                data: (host) {
                  if (host == null) {
                    return const Center(child: Text('お手伝いが存在していません。'));
                  }
                  // UrlのhostIdとログイン中のユーザーのhostIdが違う場合
                  if (host.hostId != hostId) {
                    return const Center(
                      child: Text('編集の権限がありません。'),
                    );
                  }
                  return HostForm.update(workerId: hostId, host: host);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(
                  child: Text('仕事情報が取得できませんでした。'),
                ),
              );
        },
      ),
    );
  }
}
