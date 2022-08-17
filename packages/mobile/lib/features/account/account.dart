import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/auth/auth.dart';
import '../../utils/exceptions/common.dart';

/// サインイン中のユーザーの account ドキュメントを購読する StreamProvider。
final accountProvider = StreamProvider.autoDispose<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.read(accountRepositoryProvider).subscribeAccount(accountId: userId);
});

/// サインイン中のユーザーがホストかどうかを取得する StreamProvider。
final isHostProvider = Provider.autoDispose<bool>((ref) {
  final account = ref.watch(accountProvider).value;
  return account?.isHost ?? false;
});

/// サインイン中のユーザーの DocumentReference<Account> を取得する Provider
/// 未サインインの場合は例外をスローする。
final accountRefProvider = Provider.autoDispose<DocumentReference<Account>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return ref.read(accountRepositoryProvider).accountRef(accountId: userId);
});
