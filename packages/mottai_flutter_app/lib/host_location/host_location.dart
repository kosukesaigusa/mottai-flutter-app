import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

/// 指定した `hostId` に対応する [HostLocation] を購読する [StreamProvider].
final hostLocationStreamProvider =
    StreamProvider.family.autoDispose<ReadHostLocation?, String>((ref, hostId) {
  return ref
      .watch(hostLocationRepositoryProvider)
      .subscribeHostLocation(hostLocationId: hostId);
});

final hostLocationServiceProvider = Provider.autoDispose<HostLocationService>(
  (ref) => HostLocationService(
    hostLocationRepository: ref.watch(hostLocationRepositoryProvider),
  ),
);

class HostLocationService {
  const HostLocationService({
    required HostLocationRepository hostLocationRepository,
  }) : _hostLocationRepository = hostLocationRepository;

  final HostLocationRepository _hostLocationRepository;

  /// [HostLocation] の情報を作成する。
  Future<void> create({
    required String hostId,
    required String address,
    required Geo geo,
  }) =>
      _hostLocationRepository.create(
        hostId: hostId,
        address: address,
        geo: geo,
      );

  /// [Host] の情報を更新する。
  Future<void> update({
    required String hostLocationId,
    String? address,
    Geo? geo,
  }) =>
      _hostLocationRepository.update(
        hostLocationId: hostLocationId,
        address: address,
        geo: geo,
      );
}
