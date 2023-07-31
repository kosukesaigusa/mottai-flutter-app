import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

/// 指定した [Host] ドキュメントを購読する [StreamProvider].
final hostStreamProvider = StreamProvider.family.autoDispose<ReadHost?, String>(
  (ref, hostId) =>
      ref.watch(hostRepositoryProvider).subscribeHost(hostId: hostId),
);

/// 指定した [Host] の画像 URL を返す [Provider].
/// 画像が存在しない場合や読み込み中・エラーの場合でもから文字を返す。
final hostImageUrlProvider =
    Provider.family.autoDispose<String, String>((ref, hostId) {
  final host = ref.watch(hostStreamProvider(hostId)).valueOrNull;
  return host?.imageUrl ?? '';
});

/// 指定した [Host] の名前を返す [Provider].
/// 読み込み中・エラーの場合は'農家さん'を返す。
final hostDisplayNameProvider =
    Provider.family.autoDispose<String, String>((ref, hostId) {
  final host = ref.watch(hostStreamProvider(hostId)).valueOrNull;
  return host?.displayName ?? '農家さん';
});

final hostFutureProvider = FutureProvider.family.autoDispose<ReadHost?, String>(
  (ref, id) => ref.watch(hostServiceProvider).fetchHost(hostId: id),
);

final hostServiceProvider = Provider.autoDispose<HostService>(
  (ref) => HostService(
    hostRepository: ref.watch(hostRepositoryProvider),
  ),
);

class HostService {
  const HostService({required HostRepository hostRepository})
      : _hostRepository = hostRepository;

  final HostRepository _hostRepository;

  /// 指定した [Host] が存在するかどうかを返す。
  Future<bool> hostExists({required String hostId}) async {
    final host = await _hostRepository.fetchHost(hostId: hostId);
    return host != null;
  }

  /// 指定した [Host] を取得する。
  Future<ReadHost?> fetchHost({required String hostId}) =>
      _hostRepository.fetchHost(hostId: hostId);
}
