import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

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

    test('test formatRelativeDate for today', () {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day, 12, 15);
      final formattedRelativeDate = date.formatRelativeDate();

      expect(formattedRelativeDate, DateFormat('HH:mm').format(date));
    });

    test('test formatRelativeDate for yesterday', () {
      final now = DateTime.now();
      final date = DateTime(
        now.year,
        now.month,
        now.day - 1,
      );
      final formattedRelativeDate = date.formatRelativeDate();

      expect(formattedRelativeDate, '昨日');
    });

    for (var i = 2; i <= 7; i++) {
      test('test formatRelativeDate for $i daysBefore', () {
        final now = DateTime.now();
        final date = DateTime(now.year, now.month, now.day - i);
        final formattedRelativeDate = date.formatRelativeDate();

        expect(formattedRelativeDate, '$i日前');
      });
    }

    test('test formatRelativeDate for over a week ago', () {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day - 8);
      final formattedRelativeDate = date.formatRelativeDate();

      expect(formattedRelativeDate, DateFormat('yyyy年MM月dd日').format(date));
    });
  });
}
