import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider =
    Provider<PackageInfo>((_) => throw UnimplementedError());

/// アプリバージョンを文字列を受け取り、対応する数値を返す。
///
/// 例
///
/// ```dart
/// print(formatVersionNumber('0.0.1')); // 1
///
/// print(formatVersionNumber('0.1.0')); // 10
///
/// print(formatVersionNumber('1.0.0')); // 100
/// ```
int formatVersionNumber(String versionString) {
  final stringBuffer = StringBuffer();
  final versionNumbers = versionString.split('.');
  stringBuffer.writeAll(versionNumbers);
  return int.parse(stringBuffer.toString());
}

/// 現在のアプリバージョンが、最小必要バージョンよりも小さいかどうかを返す。
bool isCurrentVersionLessThanMinRequiredVersion(
  String currentVersionString,
  String minRequiredVersionString,
) {
  final currentVersion = formatVersionNumber(currentVersionString);
  final minRequiredVersion = formatVersionNumber(minRequiredVersionString);
  return currentVersion < minRequiredVersion;
}
