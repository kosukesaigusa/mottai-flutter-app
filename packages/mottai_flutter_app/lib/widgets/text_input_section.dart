import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'optional_badge.dart';

/// タイトルと説明、テキストフィールドからなるセクション。
/// [Section] を使用し、`Section.content` にフィールドを与えている。
class TextInputSection<T extends dynamic> extends StatelessWidget {
  /// テキスト入力のみをさせる通常の [TextInputSection] を作成する。
  const TextInputSection({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.controller,
    this.isRequired = false,
    super.key,
  })  : choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// テキスト入力と選択肢を併せて入力させる [TextInputSection] を作成する。
  const TextInputSection.withChoice({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    required this.choices,
    required this.enabledChoices,
    required this.onChoiceSelected,
    this.controller,
    this.isRequired = false,
    super.key,
  });

  /// セクションのタイトル。
  final String title;

  /// セクションの説明。
  final String? description;

  /// テキストフィールドの最大行数
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数
  final int defaultDisplayLines;

  /// テキストフィールドの下に表示する選択肢
  /// 選択された際の値がkeyで、表示する値がvalueの[Map]で受け取る。
  final Map<T, String> choices;

  /// [choices] の有効な値のリスト
  final List<T> enabledChoices;

  /// [choices] が選択された際のコールバック
  final void Function(T item)? onChoiceSelected;

  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  /// 必須入力か否か
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Section(
      title: title,
      titleBadge: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: OptionalBadge(isRequired: isRequired),
      ),
      titleStyle: Theme.of(context).textTheme.titleLarge,
      description: description,
      descriptionStyle: Theme.of(context).textTheme.bodyMedium,
      sectionPadding: const EdgeInsets.only(bottom: 32),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: (value) {
              if (isRequired && (value ?? '').isEmpty) {
                return '入力してください。';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: List.filled(defaultDisplayLines - 1, '\n').join(),
              border: const OutlineInputBorder(),
            ),
          ),
          if (choices.isNotEmpty) ...[
            const Gap(16),
            SelectableChips<T>(
              allItems: choices.keys,
              labels: choices,
              runSpacing: 8,
              enabledItems: enabledChoices,
              onTap: onChoiceSelected,
            ),
          ],
        ],
      ),
    );
  }
}
