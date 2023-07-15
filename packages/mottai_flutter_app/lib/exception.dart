import 'package:dart_flutter_common/dart_flutter_common.dart';

/// アプリ内で使用する [Exception] 型。
class AppException implements Exception {
  const AppException({
    this.code,
    this.message,
    this.defaultMessage = 'エラーが発生しました。',
  });

  /// ステータスコードや独自のエラーコードなどのエラー種別を識別するための文字列
  final String? code;

  /// 例外の内容を説明するメッセージ
  final String? message;

  /// message が空の場合に使用されるメッセージ
  final String defaultMessage;

  @override
  String toString() {
    if (code == null) {
      return (message ?? '').ifIsEmpty(defaultMessage);
    }
    return '[$code] ${(message ?? '').ifIsEmpty(defaultMessage)}';
  }
}
