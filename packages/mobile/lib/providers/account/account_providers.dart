import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/providers/auth/auth_providers.dart';
import 'package:mottai_flutter_app_models/models.dart';

/// ユーザーの account ドキュメントを購読する Provider
final accountProvider = StreamProvider<Account?>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    return Stream.value(null);
  }
  return AccountRepository.subscribeAccount(accountId: userId);
});
