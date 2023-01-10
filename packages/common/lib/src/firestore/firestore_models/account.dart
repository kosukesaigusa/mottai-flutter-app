import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/utils.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    @Default('') String accountId,
    @unionTimestampConverter @Default(UnionTimestamp.serverTimestamp()) UnionTimestamp createdAt,
    @alwaysUseServerTimestampUnionTimestampConverter
    @Default(UnionTimestamp.serverTimestamp())
        UnionTimestamp updatedAt,
    @Default(false) bool isHost,
    @Default('') String displayName,
    @Default('') String imageURL,
    // TODO: Enum のコンバータを実装する。
    @Default(<String>[]) List<String> signInMethods,
    @Default(<String>[]) List<String> fcmTokens,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  factory Account.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return Account.fromJson(<String, dynamic>{
      ...data,
      'accountId': ds.id,
    });
  }
}
