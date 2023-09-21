import '../firestore_documents/host_location.dart';

class HostLocationRepository {
  final _query = HostLocationQuery();

  /// 指定した [hostLocationId] の [HostLocation] を取得する。
  Future<ReadHostLocation?> fetchHostLocation({
    required String hostLocationId,
  }) =>
      _query.fetchDocument(hostLocationId: hostLocationId);

  /// 指定した [hostLocationId] の [HostLocation] を購読する。
  Stream<ReadHostLocation?> subscribeHostLocation({
    required String hostLocationId,
  }) =>
      _query.subscribeDocument(hostLocationId: hostLocationId);

  /// [HostLocation] の情報を作成する。
  Future<void> create({
    required String hostId,
    required String address,
    required Geo geo,
  }) =>
      _query.set(
        hostLocationId: hostId,
        createHostLocation: CreateHostLocation(address: address, geo: geo),
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
        updateHostLocation: UpdateHostLocation(address: address, geo: geo),
      );
}
