import 'package:auto_route/auto_route.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';

/// [WebLink]クラスの使用イメージ
@RoutePage()
class WebLinkStubPage extends StatelessWidget {
  const WebLinkStubPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/webLinkStub';

  /// [WebLinkStubPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebLinkサンプル'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WebLink(
            urlText: 'アプリ内で表示 https://google.com',
          ),
          WebLink(
            urlText: '外部ブラウザで表示 https://google.com',
            textStyle: TextStyle(color: Colors.red),
            mode: LaunchMode.externalApplication,
          ),
          WebLink(
            urlText: 'リンクのスタイル変更 https://google.com',
            textStyle: TextStyle(color: Colors.yellow),
            linkStyle: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
