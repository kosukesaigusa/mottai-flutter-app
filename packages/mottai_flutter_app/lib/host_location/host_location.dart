import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

/// [Host] に関連する[HostLocation] を返す [FutureProvider].
final hostLocationsFromHostFutureProvider =
    FutureProvider.family.autoDispose<List<ReadHostLocation>?, String>(
  (ref, hostId) => ref
      .watch(hostLocationServiceProvider)
      .fetchHostLocationsFromHost(hostId: hostId),
);

final hostLocationServiceProvider = Provider.autoDispose<HostLocationService>(
  (ref) => HostLocationService(
    hostLocationRepository: ref.watch(hostLocationRepositoryProvider),
  ),
);

class HostLocationService {
  const HostLocationService(
      {required HostLocationRepository hostLocationRepository})
      : _hostLocationRepository = hostLocationRepository;

  final HostLocationRepository _hostLocationRepository;

  /// [Host] に関連する[HostLocation]をすべて取得する。
  Future<List<ReadHostLocation>>? fetchHostLocationsFromHost(
          {required String hostId}) =>
      _hostLocationRepository.fetchHostLocationsFromHost(hostId: hostId);

  /// [HostLocation] の情報を作成する。
  Future<void> create({
    required String hostLocationId,
    required String hostId,
    required String address,
    required Geo geo,
  }) =>
      _hostLocationRepository.create(
        hostLocationId: hostLocationId,
        hostId: hostId,
        address: address,
        geo: geo,
      );

  /// [Host] の情報を更新する。
  Future<void> update({
    required String hostLocationId,
    required String hostId,
    required String address,
    required Geo geo,
  }) =>
      _hostLocationRepository.update(
        hostLocationId: hostLocationId,
        address: address,
        geo: geo,
      );
}
