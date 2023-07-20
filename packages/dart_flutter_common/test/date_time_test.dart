import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test DateTimeExtension', () {
    test('test formatDate', () {
      final date = DateTime(1998, 5, 2);
      final formattedDate = date.formatDate();

      expect('1998年05月02日', formattedDate);
    });

     test('test formatDateTime', () {
      final date = DateTime(1998, 5, 2, 10, 7);
      final formattedDate = date.formatDateTime();

      expect('1998年05月02日 10時07分', formattedDate);
    });
  });
}
