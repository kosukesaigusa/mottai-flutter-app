import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'user_social_login.flutterfire_gen.dart';

// ドキュメント ID はユーザー ID と一致する。
@FirestoreDocument(path: 'userSocialLogins', documentName: 'userSocialLogin')
class UserSocialLogin {
  const UserSocialLogin({
    required this.isGoogleEnabled,
    required this.isAppleEnabled,
    required this.isLINEEnabled,
  });

  @ReadDefault(false)
  @CreateDefault(false)
  final bool isGoogleEnabled;

  @ReadDefault(false)
  @CreateDefault(false)
  final bool isAppleEnabled;

  @ReadDefault(false)
  @CreateDefault(false)
  final bool isLINEEnabled;
}
