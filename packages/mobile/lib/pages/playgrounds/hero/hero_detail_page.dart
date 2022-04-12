import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../route/utils.dart';
import 'hero_page.dart';

/// タップしてヒーローアニメーションで画面遷移してくる詳細ページ
class HeroImageDetailPage extends HookConsumerWidget {
  const HeroImageDetailPage._({
    Key? key,
    required this.item,
    required this.tag,
  }) : super(key: key);

  HeroImageDetailPage.withArguments({
    Key? key,
    required RouteArguments args,
  }) : this._(
          key: key,
          item: args['item'] as HeroItem,
          tag: args['tag'] as String,
        );

  static const path = '/hero-detail/';
  static const name = 'HeroImageDetailPage';

  final HeroItem item;
  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: tag,
            child: HeroCardWidget(item: item),
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
