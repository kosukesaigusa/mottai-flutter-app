import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/extensions/build_context.dart';

/// 表示内容が特にない場合に、中央に代わりのウィジェットやメッセージを表示するウィジェット。
class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({
    super.key,
    this.widget,
    this.message = '',
    this.width = 280,
  });

  final String message;
  final Widget? widget;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget != null) ...[
            widget!,
            const Gap(24),
          ],
          SizedBox(
            width: width,
            child: Center(
              child: Text(
                message.isEmpty ? '表示できるものがありません。' : message,
                style: context.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
