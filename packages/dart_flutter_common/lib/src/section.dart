import 'package:flutter/material.dart';

/// タイトルとコンテンツの文字列やウィジェットで構成された、
/// シンプルなセクションウィジェット
///
/// htmlでのイメージは以下
/// # [title]
/// <[titleSpace]分の空白>
/// [overview]
/// [content]
///
/// [content]は[overview]の後に配置される
class Section extends StatelessWidget {
  const Section({
    required this.title,
    required this.content,
    this.overview,
    this.sectionPadding,
    this.titleStyle,
    this.overviewStyle,
    this.overviewMaxLines,
    this.titleSpace = 8,
    this.titleMaxLines = 1,
    super.key,
  });

  /// セクションのタイトル
  final String title;

  final int titleMaxLines;

  /// 概要
  final String? overview;

  /// セクション全体のパディング
  final EdgeInsetsGeometry? sectionPadding;

  /// [title]のスタイル
  final TextStyle? titleStyle;

  /// [overview]のスタイル
  final TextStyle? overviewStyle;

  /// [overview]の最大行数
  final int? overviewMaxLines;

  /// セクションのウィジェットコンテンツ
  final Widget content;

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
            maxLines: titleMaxLines,
          ),
          SizedBox(
            height: titleSpace,
          ),
          if (overview != null)
            Text(
              overview!,
              style: overviewStyle,
              maxLines: overviewMaxLines,
            ),
          content,
        ],
      ),
    );
  }
}
