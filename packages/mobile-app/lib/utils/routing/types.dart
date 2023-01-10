import 'package:flutter/material.dart';

import 'app_router_state.dart';

/// GoRouterWidgetBuilder に対応する Widget ビルダー関数の型定義。
typedef AppRouterWidgetBuilder = Widget Function(
  BuildContext context,
  AppRouterState state,
);

/// MaterialApp 以外のトランジションアニメーションを行いたいときなどに使用する。
typedef AppRouterPageRoute = Route<dynamic> Function(AppRouterState state);
