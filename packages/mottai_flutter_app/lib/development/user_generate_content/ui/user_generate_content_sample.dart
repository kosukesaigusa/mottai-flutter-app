import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import '../../../block/block.dart';

@RoutePage()
class UgcSamplePage extends ConsumerStatefulWidget {
  const UgcSamplePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/ugcSample';

  /// [UgcSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  UgcSampleState createState() => UgcSampleState();
}

class UgcSampleState extends ConsumerState<UgcSamplePage> {
  /// [AutoRoute] で指定するパス文字列。
  static const path = '/ugcSample';

  /// [UgcSamplePage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  static const _jobIds = [
    '5Cqov45ZLxR5sH3JbEev',
    '9usk0ceJRA9OOcWkQGdX',
    'PYRsrMSOApEgZ6lzMuUK',
    'Riy95dPkPPFIEH1kf0ks',
    'aQf7MCsj88LoRpfYOPqX',
    'xQvXmRr26wythvz9wizf',
  ];

  static const _reviewIds = [
    '2TPCqigw8xTvju9t6hAh',
    'MlWDXBME1CSLdTNaNsmF',
  ];

  String? _selectedReportJobId;
  String? _selectedReportReviewId;
  String? _selectedBlockJobId;
  String? _selectedBlockReviewId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UGC機能サンプルページ')),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // =====Jobの通報機能=====
                _UgcContent(
                  title: 'Jobの通報処理',
                  executeText: 'Jobを通報',
                  targetItems: _jobIds,
                  item: _selectedReportJobId,
                  onSelected: (jobId) => setState(() {
                    _selectedReportJobId = jobId;
                  }),
                  onPressed: () {
                    final jobId = _selectedReportJobId;
                    if (jobId == null) {
                      return;
                    }
                    ref.watch(blockJobServiceProvider).create(
                          userId: userId,
                          jobId: jobId,
                        );
                  },
                ),

                // =====Reviewの通報機能=====
                _UgcContent(
                  title: 'Reviewの通報処理',
                  executeText: 'Reviewを通報',
                  targetItems: _reviewIds,
                  item: _selectedReportReviewId,
                  onSelected: (reviewId) => setState(() {
                    _selectedReportReviewId = reviewId;
                  }),
                  onPressed: () {
                    final reviewId = _selectedReportReviewId;
                    if (reviewId == null) {
                      return;
                    }
                    ref.watch(blockReviewServiceProvider).create(
                          userId: userId,
                          reviewId: reviewId,
                        );
                  },
                ),

                // =====Jobのブロック機能=====
                _UgcContent(
                  title: 'Jobのブロック処理',
                  executeText: 'Jobをブロック',
                  targetItems: _jobIds,
                  item: _selectedBlockJobId,
                  onSelected: (jobId) => setState(() {
                    _selectedBlockJobId = jobId;
                  }),
                  onPressed: () {
                    final jobId = _selectedBlockJobId;
                    if (jobId == null) {
                      return;
                    }
                    ref.watch(blockJobServiceProvider).create(
                          userId: userId,
                          jobId: jobId,
                        );
                  },
                ),

                // =====Reviewのブロック機能=====
                _UgcContent(
                  title: 'Reviewのブロック処理',
                  executeText: 'Reviewをブロック',
                  targetItems: _reviewIds,
                  item: _selectedBlockReviewId,
                  onSelected: (reviewId) => setState(() {
                    _selectedBlockReviewId = reviewId;
                  }),
                  onPressed: () {
                    final reviewId = _selectedBlockReviewId;
                    if (reviewId == null) {
                      return;
                    }
                    ref.watch(blockReviewServiceProvider).create(
                          userId: userId,
                          reviewId: reviewId,
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UgcContent extends StatelessWidget {
  const _UgcContent({
    required this.targetItems,
    required this.title,
    required this.executeText,
    this.item,
    this.onPressed,
    this.onSelected,
  });

  /// 対象がドロップダウンで選択されたときのコールバック
  final void Function(String?)? onSelected;

  /// 選択中のアイテム
  final String? item;

  /// 対象のアイテムリスト
  final List<String> targetItems;

  /// コンテンツのタイトル
  final String title;

  /// UGCの処理実行ボタンが押下されたときのコールバック
  final void Function()? onPressed;

  /// 実行を促すボタンのテキスト
  final String executeText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton(
              value: item,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              isExpanded: true,
              onChanged: onSelected,
              items: targetItems
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.lightbulb),
            label: Text(executeText),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
