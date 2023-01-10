import 'dart:io';

import 'base.dart';

/// Platform が iOS, Android のどちらにも該当しないときに使用する Exception
class UnsupportedPlatformException extends AppException {
  const UnsupportedPlatformException() : super();

  @override
  String get message => '${Platform.operatingSystem} はサポートされていません。';
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException(this._path);
  final String _path;

  @override
  String toString() => '$_path：指定されたページが見つかりませんでした。';
}

/// ログインが必須である場合に使用する例外。
class SignInRequiredException implements Exception {
  const SignInRequiredException();

  String get message => 'ご使用の操作やページの表示のためにはサインインが必要です。';

  @override
  String toString() => message;
}
