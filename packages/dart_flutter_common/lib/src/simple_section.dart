import 'package:flutter/material.dart';

/// タイトルとコンテンツの文字列やウィジェットで構成された、
/// シンプルなセクションウィジェット
///
/// htmlでのイメージは以下
/// # [title]
/// <[titleSpace]分の空白>
/// [content]
/// [contentWidget]
///
/// [contentWidget]は[content]の後に配置される
class SimpleSection extends StatelessWidget {
  const SimpleSection({
    required this.title,
    this.content,
    this.sectionPadding,
    this.titleStyle,
    this.contentStyle,
    this.contentMaxLines,
    this.contentWidget,
    this.titleSpace = 8,
    super.key,
  });

  /// セクションのタイトル
  final String title;

  /// セクションの文字列コンテンツ
  final String? content;

  /// セクション全体のパディング
  final EdgeInsetsGeometry? sectionPadding;

  /// [title]のスタイル
  final TextStyle? titleStyle;

  /// [content]のスタイル
  final TextStyle? contentStyle;

  /// [content]の最大行数
  final int? contentMaxLines;

  /// セクションのウィジェットコンテンツ
  final Widget? contentWidget;

  /// タイトルとコンテンツの間のスペース
  final double titleSpace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sectionPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
            maxLines: 1,
          ),
          SizedBox(
            height: titleSpace,
          ),
          if (content != null)
            Text(
              content!,
              style: contentStyle,
              maxLines: contentMaxLines,
            ),
          if (contentWidget != null) contentWidget!,
        ],
      ),
    );
  }
}
