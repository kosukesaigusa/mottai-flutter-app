import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../host_location/host_location.dart';
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
      appBar: AppBar(title: const Text('ホスト情報編集')),
      body: AuthDependentBuilder(
        onAuthenticated: (hostId) {
          return ref.watch(hostFutureProvider(hostId)).when(
                data: (host) {
                  if (host == null) {
                    return const Center(child: Text('ホストが存在していません。'));
                  }
                  return ref
                      .watch(hostLocationsFromHostFutureProvider(hostId))
                      .when(
                        data: (hostLocations) {
                          if (hostLocations == null || hostLocations.isEmpty) {
                            return const Center(
                              child: Text('ホスト所在地が存在していません。'),
                            );
                          }
                          return HostForm.update(
                            workerId: hostId,
                            host: host,
                            location: hostLocations.first,
                          );
                        },
                        error: (_, __) => const Center(
                          child: Text('ホスト所在地が取得できませんでした。'),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(
                  child: Text('ホスト情報が取得できませんでした。'),
                ),
              );
        },
      ),
    );
  }
}
