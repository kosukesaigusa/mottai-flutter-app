import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'force_update_config.flutterfire_gen.dart';

@FirestoreDocument(path: 'configurations', documentName: 'forceUpdateConfig')
class ForceUpdateConfig {
  const ForceUpdateConfig({
    required this.iOSLatestVersion,
    required this.iOSMinRequiredVersion,
    this.iOSForceUpdate = false,
    required this.androidLatestVersion,
    required this.androidMinRequiredVersion,
    this.androidForceUpdate = false,
  });

  final String iOSLatestVersion;

  final String iOSMinRequiredVersion;

  final bool iOSForceUpdate;

  final String androidLatestVersion;

  final String androidMinRequiredVersion;

  final bool androidForceUpdate;
}
