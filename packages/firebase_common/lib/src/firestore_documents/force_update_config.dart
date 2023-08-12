import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'force_update_config.flutterfire_gen.dart';

@FirestoreDocument(path: 'configurations', documentName: 'forceUpdateConfig')
class ForceUpdateConfig {
  const ForceUpdateConfig({
    required this.iOSLatestVersion,
    required this.iOSMinRequiredVersion,
    required this.iOSForceUpdate,
    required this.androidLatestVersion,
    required this.androidMinRequiredVersion,
    required this.androidForceUpdate,
  });

  final String iOSLatestVersion;

  final String iOSMinRequiredVersion;

  @ReadDefault(false)
  final bool iOSForceUpdate;

  final String androidLatestVersion;

  final String androidMinRequiredVersion;

  @ReadDefault(false)
  final bool androidForceUpdate;
}
