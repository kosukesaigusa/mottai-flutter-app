import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth.dart';

/// サインイン中のユーザーの account ドキュメントを購読する StreamProvider
final accountStreamProvider = StreamProvider.autoDispose<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(null);
  }
  return ref.read(accountRepositoryProvider).subscribeAccount(accountId: userId);
});

/// サインイン中のユーザーの account ドキュメントを取得する FutureProvider
final accountFutureProvider = FutureProvider.autoDispose<Account?>((ref) async {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Future.value();
  }
  final account = await ref.read(accountRepositoryProvider).fetchAccount(accountId: userId);
  return account;
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
