import 'dart:io';

import 'package:path/path.dart';

///
enum Flavor { local, dev, prod }

// ignore: avoid_classes_with_only_static_members
/// モバイルアプリ
class MobileAppTool {
  static const relativeRootDir = 'packages/mobile/';
  static final rootDir = joinAll([Directory.current.path, relativeRootDir]);
  static final libDir = '${rootDir}lib/';
  static final iosDir = '${rootDir}ios/';
  static final androidDir = '${rootDir}android/';
  static final entryPointPath = '${rootDir}lib/main.dart';

  static const baseAppName = 'NPO MOTTAI';
  static String ipaName(Flavor flavor) => '$baseAppName.${flavor.name}.ipa';
  static String ipaPath(Flavor flavor) => '${rootDir}build/ios/ipa/${ipaName(flavor)}';

  static final exportOptionsPath = '${iosDir}ExportOptions.plist';
}

/// ビルド番号
Future<String> get buildNumber async {
  final result = await Process.run(
    'git',
    ['rev-list', '--all', '--count'],
    runInShell: true,
  );
  return (int.parse(result.stdout.toString()) + 10000).toString();
}

///
Future<ProcessResult> shell(
  String executable,
  List<String> arguments,
) async {
  return Process.run(
    executable,
    arguments,
    runInShell: true,
  );
}
