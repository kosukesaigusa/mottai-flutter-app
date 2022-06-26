import '../../constants/string.dart';
import 'string.dart';

extension ObjectExtension on Object {
  /// Riverpod の .when(error: (Object, StackTrace?) {}) などで
  /// 画面に表示して差し支えないメッセージを返す。
  String get displayMessage {
    final message = toString()
        .trimLeft()
        .trimRight()
        .replaceAll('Exception: ', '')
        .replaceAll(RegExp(r'^Exception$'), '');
    return message.ifIsEmpty(generalExceptionMessage);
  }
}
