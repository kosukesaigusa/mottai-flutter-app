import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'in_review_config.flutterfire_gen.dart';

@FirestoreDocument(path: 'configurations', documentName: 'inReviewConfig')
class InReviewConfig {
  const InReviewConfig({
    required this.iOSInReviewVersion,
    required this.enableIOSInReviewMode,
    required this.androidInReviewVersion,
    required this.enableAndroidInReviewMode,
  });

  @ReadDefault('1.0.0')
  final String iOSInReviewVersion;

  @ReadDefault(false)
  final bool enableIOSInReviewMode;

  @ReadDefault('1.0.0')
  final String androidInReviewVersion;

  @ReadDefault(false)
  final bool enableAndroidInReviewMode;
}
