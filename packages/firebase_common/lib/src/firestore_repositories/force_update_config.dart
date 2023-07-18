import '../firestore_documents/force_update_config.dart';

class ForceUpdateConfigRepository {
  final _query = ForceUpdateConfigQuery();

  /// [ReadForceUpdateConfig] を購読する。
  Stream<List<ReadForceUpdateConfig>> subscribeForceUpdateConfig() =>
      _query.subscribeDocuments();
}
