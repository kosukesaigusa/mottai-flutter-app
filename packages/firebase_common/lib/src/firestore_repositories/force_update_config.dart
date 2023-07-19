import '../firestore_documents/force_update_config.dart';

class ForceUpdateConfigRepository {
  final _query = ForceUpdateConfigQuery();

  /// [ReadForceUpdateConfig] を購読する。
  Stream<ReadForceUpdateConfig?> subscribeForceUpdateConfig() =>
      _query.subscribeDocument(forceUpdateConfigId: 'forceUpdateConfig');
}
