import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app.dart';
import '../../utils/provider_scope.dart';

/// runApp() の引数にするべき
/// アプリケーションのルートのウィジェット
class RootWidget extends StatefulWidget {
  const RootWidget({
    super.key,
    required this.overrides,
  });

  final List<Override> overrides;

  static Future<void> restart(BuildContext context) async {
    // アプリの再起動に際して、ProviderScope の overrides を再度やり直す
    final overrides = await providerScopeOverrides;
    // ignore: use_build_context_synchronously
    context.findAncestorStateOfType<_RootWidgetState>()!.restart(overrides);
  }

  @override
  State<StatefulWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  Key _key = UniqueKey();
  List<Override> _overrides = [];

  void restart(List<Override> overrides) {
    setState(() {
      _key = UniqueKey();
      _overrides = overrides;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: ProviderScope(
        // ProviderScope の overrides したい Provider やその値を列挙する。
        // 起動時に一回インスタンス化したキャッシュを使いませせるようにすることで、
        // それ以降 await なしでアクセスしたいときなどに便利。
        overrides: _overrides.isEmpty ? widget.overrides : _overrides,
        child: const App(),
      ),
    );
  }
}
