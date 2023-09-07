// import '../firestore_documents/host_location.dart';

import '../../firebase_common.dart';

class HostLocationRepository {
  final _query = HostLocationQuery();

  /// 指定した [HostLocation] を取得する。
  Future<ReadHostLocation?> fetchHostLocation({
    required String hostLocationId,
  }) =>
      _query.fetchDocument(hostLocationId: hostLocationId);

  /// [Host]から関連する[HostLocation]をすべて取得する。
  Future<List<ReadHostLocation>> fetchHostLocationsFromHost({
    required String hostId,
  }) =>
      _query.fetchDocuments(
        queryBuilder: (query) => query.where('hostId', isEqualTo: hostId),
      );

  /// [HostLocation] の情報を作成する。
  Future<void> create({
    required String hostLocationId,
    required String hostId,
    required String address,
    required Geo geo,
  }) =>
      _query.set(
        hostLocationId: hostLocationId,
        createHostLocation: CreateHostLocation(
          hostId: hostId,
          address: address,
          geo: geo,
        ),
      );

  /// [HostLocation] の情報を更新する。
  Future<void> update({
    required String hostLocationId,
    // hostIdは更新することがないので受け取らない
    required String? address,
    required Geo? geo,
  }) =>
      _query.update(
        hostLocationId: hostLocationId,
        updateHostLocation: UpdateHostLocation(
          address: address,
          geo: geo,
        ),
      );
}
