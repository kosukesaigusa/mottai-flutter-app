import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../package_info.dart';
import '../in_review.dart';

@RoutePage()
class InReviewPage extends ConsumerWidget {
  const InReviewPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/inReview';

  /// [InReviewPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'レビュー情報',
        ),
      ),
      body: ref.watch(inReviewStreamProvider).when(
            data: (inReviewConfig) => SingleChildScrollView(
              child: inReviewConfig != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            ref.watch(packageInfoProvider).version,
                          ),
                          subtitle: const Text('packageInfoProvider'),
                        ),
                        ListTile(
                          title: Text(
                            inReviewConfig.enableIOSInReviewMode.toString(),
                          ),
                          subtitle: const Text('enableIOSInReviewMode'),
                        ),
                        ListTile(
                          title: Text(
                            inReviewConfig.iOSInReviewVersion,
                          ),
                          subtitle: const Text('iOSInReviewVersion'),
                        ),
                        ListTile(
                          title: Text(
                            inReviewConfig.enableAndroidInReviewMode.toString(),
                          ),
                          subtitle: const Text('enableAndroidInReviewMode'),
                        ),
                        ListTile(
                          title: Text(
                            inReviewConfig.androidInReviewVersion,
                          ),
                          subtitle: const Text('androidInReviewVersion'),
                        ),
                        ListTile(
                          title: Text(
                            ref.watch(isInReviewProvider).toString(),
                          ),
                          subtitle: const Text('isInReviewProvider'),
                        ),
                        if (ref.watch(isInReviewProvider))
                          ElevatedButton(
                            onPressed: () async {},
                            child: const Text('レビュー中かつバージョンが同じなら消える'),
                          ),
                      ],
                    )
                  : const SizedBox(),
            ),
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
