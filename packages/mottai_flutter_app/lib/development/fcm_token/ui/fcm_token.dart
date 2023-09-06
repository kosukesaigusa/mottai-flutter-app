import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import '../fcm_token.dart';

@RoutePage()
class FcmTokenPage extends ConsumerWidget {
  const FcmTokenPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/fcmToken';

  /// [FcmTokenPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FcmToken表示ページ'),
      ),
      body: AuthDependentBuilder(
        onAuthenticated: (hostId) {
          return FutureBuilder(
            future: getUserDeviceInfo(ref),
            builder: (context, userDeviceInfo) {
              if (userDeviceInfo.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return userDeviceInfo.data == null
                  ? const Center(
                      child: Text('デバイス情報の取得に失敗しました。'),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('token: ${userDeviceInfo.data!.token}'),
                          const Gap(24),
                          Text(
                            'deviceInfo: ${userDeviceInfo.data!.deviceInfo}',
                          ),
                          const Gap(24),
                          Text(
                            'createAt: ${userDeviceInfo.data!.createdAt}',
                          ),
                        ],
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
