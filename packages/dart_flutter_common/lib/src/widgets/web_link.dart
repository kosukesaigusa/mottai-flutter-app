import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:url_launcher/url_launcher.dart' show LaunchMode;

/// 押下するとブラウザを起動して、URLへアクセスするウィジェット
/// [urlText]に含まれているURLを検査して、リンクへ変換する。
/// リンクを押下することで指定した[mode]でリンクにアクセスをする。
/// [urlText]の中に有効なリンクが一つも含まれていない場合には、[textStyle]で指定されたTextを返す。
///
/// このウィジェットはurl_launcherを使用しています。
/// そのため、[こちらの設定](https://pub.dev/packages/url_launcher#configuration)を行ってください。
/// 設定していないと、常に[urlText]には有効なリンクがないと判定されます。
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
    return FutureBuilder<bool>(
      future: _isIncludeCorrectUrl(urlText),
      builder: (context, snapshot) {
        // URLのチェックが完了後で、URLが有効な場合
        if (snapshot.hasData && snapshot.data!) {
          // Linkifyウィジェットを返す
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
        // URLのチェックが完了する前、もしくは有効なURLなしの場合
        else {
          // 押下できないTextを返す
          return Text(urlText, style: textStyle);
        }
      },
    );
  }

  /// [text]の中に有効なURLが含まれているかチェックする。
  /// 一つでも有効なURLが含まれていた場合はtrueを返す。
  /// そのため、「<有効なURL>, <無効なURL>」のような文字列でもtrueを返すので注意
  ///
  /// - 例
  ///   ```dart
  ///   _isIncludeCorrectUrl("aaa http://google.com"); // true
  ///   _isIncludeCorrectUrl("aaa http://googlea.com"); // false
  ///   _isIncludeCorrectUrl("aaa http://googlea.com http://google.com"); // true
  ///   ```
  Future<bool> _isIncludeCorrectUrl(String text) async {
    for (final element in linkify(text)) {
      if (element is UrlElement) {
        // url_launcherの設定が正しくできているか
        if (await canLaunchUrl(Uri.parse(element.url))) {
          return true;
        }
      }
    }

    return false;
  }
}
