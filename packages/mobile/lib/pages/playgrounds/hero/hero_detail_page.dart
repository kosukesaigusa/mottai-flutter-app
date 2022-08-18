import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/playground/hero_item.dart';
import '../../../utils/exceptions/base.dart';
import '../../../utils/routing/app_router_state.dart';
import 'hero_page.dart';

final _heroItemProvider = Provider.autoDispose<HeroItem>(
  (ref) {
    final heroItem = ref.read(extractExtraDataProvider)<HeroItem>();
    if (heroItem == null) {
      throw const AppException(message: 'データが見つかりませんでした。');
    }
    return heroItem;
  },
  dependencies: [
    extractExtraDataProvider,
    appRouterStateProvider,
  ],
);

/// タップしてヒーローアニメーションで画面遷移してくる詳細ページ
class HeroImageDetailPage extends HookConsumerWidget {
  const HeroImageDetailPage({super.key});

  static const path = '/hero-detail';
  static const name = 'HeroImageDetailPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroItem = ref.watch(_heroItemProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: size.width,
                minHeight: size.height,
              ),
              child: Hero(
                tag: heroItem.tag,
                child: HeroCardWidget(heroItem: heroItem),
              ),
            ),
          ),
          Positioned(
            top: 32,
            left: 8,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
