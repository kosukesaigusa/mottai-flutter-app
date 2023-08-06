import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'user_social_login.flutterfire_gen.dart';

@FirestoreDocument(path: 'userSocialLogins', documentName: 'userSocialLogin')
class UserSocialLogin {
  const UserSocialLogin({
    this.isGoogleEnabled = false,
    this.isLINEEnabled = false,
    this.isAppleEnabled = false,
  });

  final bool isGoogleEnabled;

  final bool isLINEEnabled;

  final bool isAppleEnabled;
}
