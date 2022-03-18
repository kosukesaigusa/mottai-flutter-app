import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/providers/auth/auth_providers.dart';
import 'package:mottai_flutter_app_models/models.dart';

/// ユーザーの account ドキュメントを購読する StreamProvider
final accountStreamProvider = StreamProvider<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(null);
  }
  return AccountRepository.subscribeAccount(accountId: userId);
});

/// ユーザーの account ドキュメントを取得する FutureProvider
final accountFutureProvider = FutureProvider<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Future.value(null);
  }
  return AccountRepository.fetchAccount(accountId: userId);
});

/// ユーザーの account の DocumentReference を取得する Provider
final accountRefProvider = Provider<DocumentReference<Account>>((ref) {
  // TODO: Non-null の保証はないが、返り値は Non-null で気軽に使いたいので良い方法を考える
  final userId = ref.watch(userIdProvider).value!;
  // if (userId == null) {
  //   return Future.value(null);
  // }
  return AccountRepository.accountRef(accountId: userId);
});
