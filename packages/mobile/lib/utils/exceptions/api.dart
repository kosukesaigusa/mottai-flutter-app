import 'base.dart';

/// HTTP 通信時に使用する例外型。
class ApiException extends AppException implements Exception {
  const ApiException({
    super.code,
    super.message,
    super.defaultMessage = 'サーバとの通信に失敗しました。',
  });
}

/// HTTP リクエストで 401 が発生した場合の例外
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message})
      : super(
          code: '401',
          defaultMessage: '認証されていません。',
        );
}

/// HTTP リクエストで 403 が発生した場合の例外
class ForbiddenException extends ApiException {
  const ForbiddenException({super.message})
      : super(
          code: '403',
          defaultMessage: '指定した操作を行う権限がありません。',
        );
}

/// HTTP リクエストで 404 が発生した場合の例外
class ApiNotFoundException extends ApiException {
  const ApiNotFoundException({super.message})
      : super(
          code: '404',
          defaultMessage: 'リクエストした API が見つかりませんでした。',
        );
}

/// HTTP リクエストがタイムアウトした場合の例外
class ApiTimeoutException extends ApiException {
  const ApiTimeoutException({super.message})
      : super(
          defaultMessage: 'API 通信がタイムアウトしました。'
              '通信環境をご確認のうえ、再度実行してください。',
        );
}

/// HTTP リクエスト時のネットワーク接続に問題がある場合の例外
class NetworkNotConnectedException extends ApiException {
  const NetworkNotConnectedException({super.message})
      : super(
          defaultMessage: 'ネットワーク接続がありません。',
        );
}
