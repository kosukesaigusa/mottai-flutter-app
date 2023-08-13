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
    this.chipPadding = const EdgeInsets.only(right: 8),
    this.isDisplayDisable = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.onTap,
    super.key,
  });

  /// 選択可能な選択肢。
  final Iterable<T> allItems;

  /// 選択肢をキーにしたデータのラベル。
  final Map<T, String> labels;

  /// 有効な選択肢。
  final Iterable<T> enabledItems;

  /// チップ一つのパディング。
  final EdgeInsetsGeometry chipPadding;

  /// [enabledItems] に含まれていないチップを非表示にするか否か。
  final bool isDisplayDisable;

  /// [Wrap] で並べる方向。
  final Axis direction;

  /// [direction] 方向の並び方。
  final WrapAlignment alignment;

  /// [direction] と垂直方向の並び方。
  final WrapCrossAlignment crossAxisAlignment;

  /// チップが押されたときのコールバック
  final void Function(T item)? onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: allItems
          .where(
            (item) => enabledItems.contains(item) || isDisplayDisable,
          )
          .map(
            (item) => Padding(
              padding: chipPadding,
              child: _SwitchingChip(
                label: labels[item] ?? '',
                isEnabled: enabledItems.contains(item),
                onTap: () => onTap?.call(item),
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
    this.onTap,
  });

  final bool isEnabled;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputChip(
        onPressed: onTap, // コールバックを設定しないとデザインが変わるので、設定している
        isEnabled: isEnabled,
        side: isEnabled ? BorderSide.none : null,
        label: Text(label),
      ),
    );
  }
}
