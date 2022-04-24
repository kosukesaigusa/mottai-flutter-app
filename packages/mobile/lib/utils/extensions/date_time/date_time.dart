import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toYYYYMMDD({String delimiter = '-'}) =>
      DateFormat('yyyy${delimiter}MM${delimiter}dd').format(this);

  ///
  String toYYYYMMDDHHMM({String delimiter = '-'}) =>
      DateFormat('yyyy${delimiter}MM${delimiter}dd HH:mm').format(this);
}
