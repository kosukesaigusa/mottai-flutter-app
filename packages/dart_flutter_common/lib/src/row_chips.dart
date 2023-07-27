import 'package:flutter/material.dart';

import './switching_chip.dart';

/// 横並びのchipウィジェット
/// 画面端で改行する。
/// 引数として選択可能なすべての選択肢[allData]と
/// 実際に選択されている選択肢[enableData]を受け取る。
/// オプションで選択されていないデータの表示非表示を選択可能
class RowChips<T> extends StatelessWidget {
  const RowChips({
    required this.allData,
    required this.allLable,
    required this.enableData,
    this.chipPadding = const EdgeInsets.only(right: 8),
    this.isDisplayDisable = true,
    super.key,
  });

  /// 選択可能な選択肢
  final Iterable<T> allData;

  /// 選択肢をキーにしたデータのラベル
  final Map<T, String> allLable;

  /// 有効な選択肢
  final Iterable<T> enableData;

  /// チップ一つのパディング
  final EdgeInsetsGeometry chipPadding;

  /// [enableData]に含まれていないチップを非表示にするか否か
  final bool isDisplayDisable;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChipList(),
    );
  }

  List<Widget> _buildChipList() {
    final chipList = <Widget>[];

    for (final data in allData) {
      final isContain = enableData.contains(data);

      if (!isContain && !isDisplayDisable) {
        continue;
      }

      chipList.add(
        Padding(
          padding: chipPadding,
          child: SwitchingChip(
            label: allLable[data] ?? '',
            isEnabled: isContain,
          ),
        ),
      );
    }
    return chipList;
  }
}
