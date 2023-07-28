import 'package:flutter_test/flutter_test.dart';
import 'package:mottai_flutter_app/package_info.dart';

Future<void> main() async {
  group('バージョン情報をStringからint型に変換するメソッドのテスト', () {
    test('0.0.1→1', () => expect(formatVersionNumber('0.0.1'), 1));
    test('0.1.0→10', () => expect(formatVersionNumber('0.1.0'), 10));
    test('1.0.0→100', () => expect(formatVersionNumber('1.0.0'), 100));
  });
  group('現在バージョンが最低限バージョンより小さいかを判定するメソッドのテスト', () {
    test(
      '現在バージョン<最低限バージョンはtrue',
      () => expect(isCurrentVersionLessThanMinimum('0.0.1', '0.0.2'), true),
    );
    test(
      '現在バージョン<=最低限バージョンはfalse',
      () => expect(isCurrentVersionLessThanMinimum('0.1.0', '0.1.0'), false),
    );
    test(
      '現在バージョン>最低限バージョンはfalse',
      () => expect(isCurrentVersionLessThanMinimum('1.0.0', '0.0.1'), false),
    );
  });
}
