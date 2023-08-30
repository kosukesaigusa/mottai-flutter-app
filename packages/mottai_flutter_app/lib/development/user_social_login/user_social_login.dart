import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/auth.dart';
import '../../auth/ui/auth_controller.dart';
import '../../auth/ui/auth_dependent_builder.dart';

@RoutePage()
class UserSocialLoginSamplePage extends ConsumerWidget {
  const UserSocialLoginSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/userSocialLoginSample';

  /// [UserSocialLoginSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ソーシャル認証連携サンプルページ'),
      ),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          final userSocialLogin = ref.watch(
            userSocialLoginStreamProvider(userId),
          );

          return userSocialLogin.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (e, s) => Center(child: Text(e.toString())),
            data: (data) {
              if (data == null) {
                return const Center(
                  child: Text('まだ UserSocialLogin が作成されていないようです。'),
                );
              }
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (data.isGoogleEnabled) {
                        return ref
                            .read(authControllerProvider)
                            .unLinkUserSocialLogin(
                              signInMethod: SignInMethod.google,
                              userId: userId,
                              userSocialLogin: data,
                            );
                      }
                      await ref
                          .read(authControllerProvider)
                          .linkUserSocialLogin(
                            signInMethod: SignInMethod.google,
                            userId: userId,
                          );
                    },
                    child:
                        Text(data.isGoogleEnabled ? 'Google解除' : 'Google連携する'),
                  ),
                  Visibility(
                    visible: Platform.isIOS,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (data.isAppleEnabled) {
                          return ref
                              .read(authControllerProvider)
                              .unLinkUserSocialLogin(
                                signInMethod: SignInMethod.apple,
                                userId: userId,
                                userSocialLogin: data,
                              );
                        }
                        await ref
                            .read(authControllerProvider)
                            .linkUserSocialLogin(
                              signInMethod: SignInMethod.apple,
                              userId: userId,
                            );
                      },
                      child: Text(data.isAppleEnabled ? 'Apple解除' : 'Apple連携する'),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
