import 'package:flutter/material.dart';

import './switching_chip.dart';

/// 横並びのchipウィジェット
/// 画面端で改行する。
/// 引数として選択可能なすべての選択肢[allItems]と
/// 実際に選択されている選択肢[enableItems]を受け取る。
/// オプションで選択されていないデータの表示非表示を選択可能
class ChipsSelector<T> extends StatelessWidget {
  const ChipsSelector({
    required this.allItems,
    required this.labels,
    required this.enableItems,
    this.chipPadding = const EdgeInsets.only(right: 8),
    this.isDisplayDisable = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    super.key,
  });

  /// 選択可能な選択肢
  final Iterable<T> allItems;

  /// 選択肢をキーにしたデータのラベル
  final Map<T, String> labels;

  /// 有効な選択肢
  final Iterable<T> enableItems;

  /// チップ一つのパディング
  final EdgeInsetsGeometry chipPadding;

  /// [enableItems]に含まれていないチップを非表示にするか否か
  final bool isDisplayDisable;

  /// chipの並べられる方向
  final Axis direction;

  /// [direction]方向の並び方
  final WrapAlignment alignment;

  /// [direction]と垂直方向の並び方
  final WrapCrossAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: allItems
          .where(
            (item) => enableItems.contains(item) || isDisplayDisable,
          )
          .map(
            (item) => Padding(
              padding: chipPadding,
              child: _SwitchingChip(
                label: labels[item] ?? '',
                isEnabled: enableItems.contains(item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SwitchingChip extends StatelessWidget {
  const _SwitchingChip({
    required this.label,
    this.isEnabled = false,
  });

  final bool isEnabled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      onPressed: () => {},
      isEnabled: isEnabled,
      side: isEnabled ? BorderSide.none : null,
      label: Text(label),
    );
  }
}
