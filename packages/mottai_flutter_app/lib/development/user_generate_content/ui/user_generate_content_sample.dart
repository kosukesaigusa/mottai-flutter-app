import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  String? _selectJobId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UGC機能サンプルページ')),
      body: Column(
        children: [
          // =====Jobの通報機能=====
          _UgcContent(
            title: 'Jobの通報処理',
            executeText: 'Jobを通報',
            targetItems: _jobIds,
            item: _selectJobId,
            onSelected: (jobId) => setState(() {
              _selectJobId = jobId;
            }),
            onPressed: () {},
          ),
        ],
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
          )
        ],
      ),
    );
  }
}
