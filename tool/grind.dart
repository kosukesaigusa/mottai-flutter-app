import 'package:grinder/grinder.dart';

import 'environments.dart';
import 'utils.dart';

main(List<String> args) => grind(args);

/// モバイルアプリに対して静的解析を実行する
@Task('analyzeMobile')
void analyze() {
  Analyzer.analyze([MobileAppTool.libDir]);
}

/// Dev 版 ipa をビルドして TestFlight に提出する
@Task('dev-ipa')
void devIpa() {
  _buildIos(flavor: Flavor.dev, buildName: '1.0.0');
}

/// Dev 版 ipa をビルドして TestFlight に提出する
@Task('test')
Future<void> test() async {
  final a = await buildNumber;
  print(a);
}

///
Future<void> _buildIos({
  required Flavor flavor,
  required String buildName,
}) async {
  await runAsync(
    'flutter',
    arguments: [
      'build',
      'ipa',
      '--release',
      '--dart-define=FLAVOR=${flavor.name}',
      '-t',
      '${MobileAppTool.entryPointPath}',
      '--build-name',
      '$buildName',
      '--build-number',
      '${await buildNumber}',
      '--export-options-plist=${MobileAppTool.exportOptionsPath}',
    ],
  );
  await runAsync(
    'xcrun',
    arguments: [
      'altool',
      '--validate-app',
      '-f "${MobileAppTool.ipaPath(flavor)}"',
      '-t ios',
      '--apiKey ${DevEnv.apiKeyId}',
      '--apiIssuer ${DevEnv.apiIssuerId}',
    ],
  );
  await runAsync(
    'xcrun',
    arguments: [
      'altool',
      '--upload-app',
      '-f "${MobileAppTool.ipaPath(flavor)}"'
          '-t ios',
      '--apiKey ${DevEnv.apiKeyId}',
      '--apiIssuer ${DevEnv.apiIssuerId}',
    ],
  );
}
