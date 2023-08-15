import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'user_fcm_token.flutterfire_gen.dart';

// ドキュメント ID は FCM Token と一致する。
@FirestoreDocument(path: 'userFcmTokens', documentName: 'userFcmToken')
class UserFcmToken {
  const UserFcmToken({
    required this.userId,
    required this.token,
    required this.deviceInfo,
    this.createdAt,
    this.updatedAt,
  });

  final String userId;

  final String token;

  @ReadDefault('')
  final String deviceInfo;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
