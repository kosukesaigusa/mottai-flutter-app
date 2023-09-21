import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'disable_user_account_request.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'disableUserAccountRequests',
  documentName: 'disableUserAccountRequest',
)
class DisableUserAccountRequest {
  const DisableUserAccountRequest({
    required this.userId,
    this.createdAt,
  });

  final String userId;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}
