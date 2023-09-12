import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../host_location/host_location.dart';
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
/// 読み込み中・エラーの場合は空文字を返す。
final hostDisplayNameProvider =
    Provider.family.autoDispose<String, String>((ref, hostId) {
  final host = ref.watch(hostStreamProvider(hostId)).valueOrNull;
  return host?.displayName ?? '';
});

/// 指定した [Host] を返す [FutureProvider].
final hostFutureProvider = FutureProvider.family.autoDispose<ReadHost?, String>(
  (ref, hostId) => ref.watch(hostServiceProvider).fetchHost(hostId: hostId),
);

final hostServiceProvider = Provider.autoDispose<HostService>(
  (ref) => HostService(
    hostRepository: ref.watch(hostRepositoryProvider),
    hostLocationService: ref.watch(hostLocationServiceProvider),
  ),
);

class HostService {
  const HostService({
    required HostLocationService hostLocationService,
    required HostRepository hostRepository,
  })  : _hostRepository = hostRepository,
        _hostLocationService = hostLocationService;

  final HostRepository _hostRepository;
  final HostLocationService _hostLocationService;

  /// 指定した [Host] が存在するかどうかを返す。
  Future<bool> hostExists({required String hostId}) async {
    final host = await _hostRepository.fetchHost(hostId: hostId);
    return host != null;
  }

  /// 指定した [Host] を取得する。
  Future<ReadHost?> fetchHost({required String hostId}) =>
      _hostRepository.fetchHost(hostId: hostId);

  /// [Host] と [HostLocation] の情報を作成する。
  Future<void> create({
    required String workerId,
    required String displayName,
    required String introduction,
    required Set<HostType> hostTypes,
    required List<String> urls,
    required String imageUrl,
    required String address,
    required Geo geo,
  }) async {
    await _hostRepository.create(
      workerId: workerId,
      displayName: displayName,
      introduction: introduction,
      hostTypes: hostTypes,
      urls: urls,
      imageUrl: imageUrl,
    );
    await _hostLocationService.create(
      hostId: workerId,
      address: address,
      geo: geo,
    );
  }

  /// [Host] と [HostLocation] の情報を更新する。
  Future<void> update({
    required String hostId,
    String? displayName,
    String? introduction,
    Set<HostType>? hostTypes,
    List<String>? urls,
    String? imageUrl,
    String? address,
    Geo? geo,
  }) async {
    await _hostRepository.update(
      hostId: hostId,
      displayName: displayName,
      introduction: introduction,
      hostTypes: hostTypes,
      urls: urls,
      imageUrl: imageUrl,
    );
    // TODO: 修正する

    // final locations =
    //     await _hostLocationService.fetchHostLocationsFromHost(hostId: hostId);
    // if (locations != null && locations.isNotEmpty) {
    //   await _hostLocationService.update(
    //     hostLocationId: locations.first.hostLocationId,
    //     address: address,
    //     geo: geo,
    //   );
    // }
  }
}
