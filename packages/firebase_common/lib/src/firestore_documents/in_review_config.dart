import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'in_review_config.flutterfire_gen.dart';

@FirestoreDocument(path: 'configurations', documentName: 'inReviewConfig')
class InReviewConfig {
  const InReviewConfig({
    required this.iOSInReviewVersion,
    this.enableIOSInReviewMode = false,
    required this.androidInReviewVersion,
    this.enableAndroidInReviewMode = false,
  });

  @ReadDefault('1.0.0')
  final String iOSInReviewVersion;

  final bool enableIOSInReviewMode;

  @ReadDefault('1.0.0')
  final String androidInReviewVersion;

  final bool enableAndroidInReviewMode;
}
