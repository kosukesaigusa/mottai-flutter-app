import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider =
    Provider<PackageInfo>((_) => throw UnimplementedError());

/// 文字列のアプリバージョンを受け取り、数値を返す
///
/// '0.0.1'→1
///
/// '0.1.0'→10
///
/// '1.0.0'→100
int formatVersionNumber(String version) {
  final sb = StringBuffer();

  final versionNumbers = version.split('.');

  sb.writeAll(versionNumbers);

  return int.parse(sb.toString());
}

bool isCurrentVersionLessThanMinimum(
  String currentVersion,
  String minRequiredVersion,
) {
  final currentVersionValue = formatVersionNumber(currentVersion);
  final minRequiredVersionValue = formatVersionNumber(minRequiredVersion);

  return currentVersionValue < minRequiredVersionValue;
}
