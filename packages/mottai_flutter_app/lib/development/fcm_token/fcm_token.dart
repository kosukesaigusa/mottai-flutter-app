import 'package:auto_route/auto_route.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../firestore_repository.dart';
import '../../push_notification/firebase_messaging.dart';

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
            future: ref.read(getFcmTokenProvider).call(),
            builder: (context, token) {
              if (token.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return token.data == null
                  ? const Center(
                      child: Text('tokenの取得に失敗しました。'),
                    )
                  : FutureBuilder(
                      future: ref.read(
                        fcmTokenFutureProvider(token.data!).future,
                      ),
                      builder: (context, useFcmToken) {
                        if (useFcmToken.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return useFcmToken.data == null
                            ? const Center(
                                child: Text('データの取得に失敗しました。'),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('token: ${useFcmToken.data!.token}'),
                                    const Gap(24),
                                    Text(
                                      'token: ${useFcmToken.data!.deviceInfo}',
                                    ),
                                    const Gap(24),
                                    Text(
                                      'token: ${useFcmToken.data!.createdAt}',
                                    ),
                                  ],
                                ),
                              );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}

/// 指定した [UserFcmToken] を取得する [FutureProvider].
final fcmTokenFutureProvider = FutureProvider.family
    .autoDispose<ReadUserFcmToken?, String>((ref, userFcmTokenId) async {
  return await ref
      .watch(fcmTokenRepositoryProvider)
      .fetchUserFcmToken(userFcmTokenId: userFcmTokenId);
});
