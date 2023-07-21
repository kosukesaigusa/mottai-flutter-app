import 'package:flutter_test/flutter_test.dart';

import 'package:mottai_flutter_app/auth/auth.dart';

void main() {
  group('AuthService test', () {
    group('sha256ofString test', () {
      /// Hash toolkitを使用して、文字列のハッシュと関数の出力が正しいか確認しています。
      /// https://hashtoolkit.com/
      test('ハッシュの生成がSHA-256でできること[input]', () {
        expect(
          'c96c6d5be8d08a12e7b5cdc1b207fa6b2430974c86803d8891675e76fd992c20',
          AuthService.sha256ofString('input'),
        );
      });

      test('ハッシュの生成がSHA-256でできること[hash text test]', () {
        expect(
          'cc74adc9106ed0e7a2d66df91fb80516b7b5215b9a4289c37e81487010b83d6c',
          AuthService.sha256ofString('hash text test'),
        );
      });
    });
  });
}
