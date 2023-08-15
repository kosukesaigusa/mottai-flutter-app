import 'package:flutter/material.dart';

/// - 必須: [title] タイトル文字列
/// - 任意: [description] 説明文字列
/// - 必須: [content] 内容を表すウィジェット
///
/// を上から順に並べて構成されるシンプルなセクションウィジェット。
class Section extends StatelessWidget {
  /// [Section] を作成する。
  const Section({
    required this.title,
    this.titleBadge,
    this.titleStyle,
    this.titleMaxLines = 1,
    this.titleBottomMargin = 16,
    this.description,
    this.descriptionStyle,
    this.descriptionMaxLines,
    this.descriptionBottomMargin = 16,
    required this.content,
    this.sectionPadding,
    super.key,
  });

  /// セクションのタイトル。
  final String title;

  /// タイトルの横に配置されるバッジ
  final Widget? titleBadge;

  /// [title] のスタイル。
  final TextStyle? titleStyle;

  /// [title] の表示行数。
  final int titleMaxLines;

  /// [title] の下の余白。
  final double titleBottomMargin;

  /// セクションの説明。
  final String? description;

  /// [description] のスタイル。
  final TextStyle? descriptionStyle;

  /// [description] の最大行数。
  final int? descriptionMaxLines;

  /// [description] の下の余白
  final double descriptionBottomMargin;

  /// セクションのコンテンツ。
  final Widget content;

  /// セクション全体のパディング。
  final EdgeInsetsGeometry? sectionPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sectionPadding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: titleStyle,
                maxLines: titleMaxLines,
              ),
              if (titleBadge != null) titleBadge!,
            ],
          ),
          SizedBox(height: titleBottomMargin),
          if (description != null) ...[
            Text(
              description!,
              style: descriptionStyle,
              maxLines: descriptionMaxLines,
            ),
            SizedBox(height: descriptionBottomMargin),
          ],
          content,
        ],
      ),
    );
  }
}
