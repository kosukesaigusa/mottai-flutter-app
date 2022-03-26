import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

/// 指定した userId の PublicUser ドキュメントを購読する StreamProvider
final publicUserStreamProvider =
    StreamProvider.autoDispose.family<PublicUser?, String>((ref, userId) {
  return PublicUserRepository.subscribePublicUser(publicUserId: userId);
});

/// 指定した userId の PublicUser ドキュメントを取得する FutureProvider
final publicUserFutureProvider =
    FutureProvider.autoDispose.family<PublicUser?, String>((ref, userId) {
  return PublicUserRepository.fetchPublicUser(publicUserId: userId);
});
