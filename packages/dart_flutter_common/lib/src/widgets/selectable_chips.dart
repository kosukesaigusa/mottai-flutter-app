import 'package:flutter/material.dart';

/// [Chip] ウィジェットを [Wrap] で囲んだ UI.
/// 画面端で改行する。
/// 引数として選択可能なすべての選択肢 [allItems] と
/// 実際に選択されている選択肢 [enabledItems] を受け取る。
/// オプションで選択されていないデータの表示非表示を選択可能である。
class SelectableChips<T> extends StatelessWidget {
  /// [SelectableChips] を作成する。
  const SelectableChips({
    required this.allItems,
    required this.labels,
    required this.enabledItems,
    this.isDisplayDisable = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 8,
    this.runSpacing = 0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.onTap,
    this.chipPadding = const EdgeInsets.all(8),
    super.key,
  });

  /// 選択可能な選択肢。
  final Iterable<T> allItems;

  /// 選択肢をキーにしたデータのラベル。
  final Map<T, String> labels;

  /// 有効な選択肢。
  final Iterable<T> enabledItems;

  /// [enabledItems] に含まれていないチップを非表示にするか否か。
  final bool isDisplayDisable;

  /// [Wrap] で並べる方向。
  final Axis direction;

  /// [direction] 方向の並び方。
  final WrapAlignment alignment;

  /// 主軸方向の各要素の余白。
  final double spacing;

  /// 主軸に垂直方向の各要素の余白。
  final double runSpacing;

  /// [direction] と垂直方向の並び方。
  final WrapCrossAlignment crossAxisAlignment;

  /// チップが押されたときのコールバック
  final void Function(T item)? onTap;

  /// チップの余白。
  final EdgeInsetsGeometry chipPadding;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: allItems
          .where(
            (item) => enabledItems.contains(item) || isDisplayDisable,
          )
          .map(
            (item) => _SwitchingChip(
              label: labels[item] ?? '',
              isEnabled: enabledItems.contains(item),
              padding: chipPadding,
              onTap: () => onTap?.call(item),
            ),
          )
          .toList(),
    );
  }
}

class _SwitchingChip extends StatelessWidget {
  const _SwitchingChip({
    required this.label,
    required this.padding,
    this.isEnabled = false,
    this.onTap,
  });

  final String label;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputChip(
        onPressed: onTap, // コールバックを設定しないとデザインが変わるので、設定している
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        isEnabled: isEnabled,
        side: isEnabled ? BorderSide.none : null,
        label: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        padding: padding,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}
