import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_pagination.dart';

/// [FirestorePaginationStateNotifier] を使用した無限スクロールの [ListView] UI.
class FirestorePaginationListView<T> extends ConsumerWidget {
  const FirestorePaginationListView({
    required this.stateNotifierProvider,
    required this.itemBuilder,
    super.key,
  });

  /// [FirestorePaginationStateNotifier] を提供する [StateNotifierProvider]。
  final AutoDisposeStateNotifierProvider<FirestorePaginationStateNotifier<T>,
      AsyncValue<List<T>>> stateNotifierProvider;

  /// [ListView.builder] で表示する各要素のビルダー関数。
  final Widget Function(BuildContext, T) itemBuilder;

  /// 画面の何割をスクロールした時点で次の _limit 件のメッセージを取得するか。
  static const _scrollValueThreshold = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateNotifierProvider);
    final notifier = ref.watch(stateNotifierProvider.notifier);
    return state.when(
      data: (items) {
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                final scrollValue = metrics.pixels / metrics.maxScrollExtent;
                if (scrollValue > _scrollValueThreshold) {
                  notifier.fetchNext();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return itemBuilder(context, item);
                },
              ),
            ),
            if (kDebugMode)
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _DebugIndicator(notifier: notifier, items: items),
                ),
              ),
          ],
        );
      },
      error: (_, __) => const SizedBox(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// TODO: あとで消す。
/// 開発時のみ表示する、無限スクロールのデバッグ用ウィジェット。
class _DebugIndicator<T> extends ConsumerWidget {
  const _DebugIndicator({
    required this.notifier,
    required this.items,
  });

  /// [FirestorePaginationStateNotifier]
  final FirestorePaginationStateNotifier<T> notifier;

  /// 取得したアイテム一覧。
  final List<T> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'デバッグウィンドウ',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
          const Gap(4),
          Text(
            '取得件数：${items.length.withComma} 件',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          Text(
            '取得中？：${notifier.isFetching}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          Text(
            'まだ取得できる？：${notifier.hasNext}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
