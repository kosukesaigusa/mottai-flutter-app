import '../../constants/string.dart';
import 'string.dart';

extension ExceptionExtension on Exception {
  /// SnackBar などで表示して差し支えのないメッセージを取得する
  String get displayMessage {
    final message = toString()
        .trimLeft()
        .trimRight()
        .replaceAll('Exception: ', '')
        .replaceAll(RegExp(r'^Exception$'), '');
    return message.ifIsEmpty(generalExceptionMessage);
  }
}
