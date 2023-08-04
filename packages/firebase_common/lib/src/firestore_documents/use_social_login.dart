import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'use_social_login.flutterfire_gen.dart';

@FirestoreDocument(path: 'useSocialLogins', documentName: 'useSocialLogin')
class UseSocialLogin {
  const UseSocialLogin({
    this.isGoogleEnabled = false,
    this.isLINEEnabled = false,
    this.isAppleEnabled = false,
  });

  final bool isGoogleEnabled;

  final bool isLINEEnabled;

  final bool isAppleEnabled;
}
