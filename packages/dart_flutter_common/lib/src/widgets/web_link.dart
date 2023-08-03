import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:url_launcher/url_launcher.dart' show LaunchMode;

/// 押下するとブラウザを起動して、URLへアクセスするウィジェット
/// リンクを押下することで指定した[mode]でリンクにアクセスをする。
///
/// このウィジェットはurl_launcherを使用している。
/// そのため、[こちらの設定](https://pub.dev/packages/url_launcher#configuration)を必ず行うこと。
class WebLink extends StatelessWidget {
  /// [WebLink] を作成する。
  const WebLink({
    required this.urlText,
    this.mode = LaunchMode.platformDefault,
    this.textStyle,
    this.linkStyle,
    this.onFailLaunch,
    super.key,
  });

  /// urlを含んだ表示文字列
  final String urlText;

  /// リンクアクセス時のモード
  /// 現状はurl_launcherで使用しているものと同じものを使用しているので
  /// [ドキュメント](https://pub.dev/documentation/url_launcher/latest/url_launcher_string/LaunchMode.html)参照
  final LaunchMode mode;

  /// [urlText]のurl以外の部分のスタイル
  final TextStyle? textStyle;

  /// [urlText]のurl部分のスタイル
  final TextStyle? linkStyle;

  /// リンク遷移が失敗した場合のコールバック
  final void Function(String url)? onFailLaunch;

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) async {
        if (!await launchUrl(
          Uri.parse(link.url),
          mode: mode,
        )) {
          onFailLaunch?.call(link.url);
        }
      },
      text: urlText,
      style: textStyle,
      linkStyle: linkStyle,
    );
  }
}
