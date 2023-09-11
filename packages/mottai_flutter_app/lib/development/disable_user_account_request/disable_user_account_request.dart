import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../firestore_repository.dart';

final disableUserAccountRequestServiceProvider =
    Provider.autoDispose<DisableUserAccountRequestService>(
  (ref) => DisableUserAccountRequestService(
    disableUserAccountRequestRepository: ref.watch(
      disableUserAccountRequestRepositoryProvider,
    ),
    authService: ref.watch(authServiceProvider),
  ),
);

class DisableUserAccountRequestService {
  const DisableUserAccountRequestService({
    required DisableUserAccountRequestRepository
        disableUserAccountRequestRepository,
        required AuthService authService,
  }) : _disableUserAccountRequestRepository =
            disableUserAccountRequestRepository,
      _authService = authService;

  final DisableUserAccountRequestRepository
      _disableUserAccountRequestRepository;
      final AuthService _authService;

  /// 引数で受ける [userId] を用いて [DisableUserAccountRequest] ドキュメントを作成し、サインアウトする
  Future<void> createDisableUserAccountRequest({
    required String userId,
  }) async {
    await _disableUserAccountRequestRepository.setDisableUserAccountRequest(
      userId: userId,
    );
    await _authService.signOut(); 
  }
}
