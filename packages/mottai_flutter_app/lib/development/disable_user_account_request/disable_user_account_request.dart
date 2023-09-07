import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

final disableUserAccountRequestServiceProvider =
    Provider.autoDispose<DisableUserAccountRequestService>(
  (ref) => DisableUserAccountRequestService(
    disableUserAccountRequestRepository: ref.watch(
      disableUserAccountRequestRepositoryProvider,
    ),
  ),
);

class DisableUserAccountRequestService {
  const DisableUserAccountRequestService({
    required DisableUserAccountRequestRepository
        disableUserAccountRequestRepository,
  }) : _disableUserAccountRequestRepository =
            disableUserAccountRequestRepository;

  final DisableUserAccountRequestRepository
      _disableUserAccountRequestRepository;

  /// 引数で受ける [userId] を用いて [DisableUserAccountRequest] ドキュメントを作成する
  Future<void> createDisableUserAccountRequest({
    required String userId,
  }) async {
    await _disableUserAccountRequestRepository.setDisableUserAccountRequest(
      userId: userId,
    );
  }
}
