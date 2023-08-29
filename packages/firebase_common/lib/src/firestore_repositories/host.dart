import '../firestore_documents/host.dart';

class HostRepository {
  final _query = HostQuery();

  /// 指定した [Host] を購読する。
  Stream<ReadHost?> subscribeHost({required String hostId}) =>
      _query.subscribeDocument(hostId: hostId);

  /// 指定した [Host] を取得する。
  Future<ReadHost?> fetchHost({required String hostId}) =>
      _query.fetchDocument(hostId: hostId);

  /// [Host] の情報を作成する。
  Future<void> create({
    required String displayName,
    required String introduction,
    required Set<HostType> hostTypes,
    required List<String> urls,
    required String imageUrl,
  }) =>
      _query.add(
        createHost: CreateHost(
          displayName: displayName,
          introduction: introduction,
          hostTypes: hostTypes,
          urls: urls,
          imageUrl: imageUrl,
        ),
      );

  /// [Host] の情報を更新する。
  Future<void> update({
    required String hostId,
    String? displayName,
    String? introduction,
    Set<HostType>? hostTypes,
    List<String>? urls,
    String? imageUrl,
  }) =>
      _query.update(
        hostId: hostId,
        updateHost: UpdateHost(
          displayName: displayName,
          introduction: introduction,
          hostTypes: hostTypes,
          urls: urls,
          imageUrl: imageUrl,
        ),
      );
}
