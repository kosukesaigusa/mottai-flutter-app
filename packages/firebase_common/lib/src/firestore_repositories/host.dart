import '../firestore_documents/host.dart';

class HostRepository {
  final _query = HostQuery();

  /// 指定した [Host] を購読する。
  Stream<ReadHost?> subscribeHost({required String hostId}) =>
      _query.subscribeDocument(hostId: hostId);

  /// 指定した [Host] を取得する。
  Future<ReadHost?> fetchHost({required String hostId}) =>
      _query.fetchDocument(hostId: hostId);
}
