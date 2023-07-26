import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

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
}
