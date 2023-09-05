import 'package:hooks_riverpod/hooks_riverpod.dart';

final disableUserAccountRequestServiceProvider =
    Provider.autoDispose<DisableUserAccountRequestService>(
  (ref) => DisableUserAccountRequestService(),
);

class DisableUserAccountRequestService {

  /// 引数で受ける [userId] を用いて [disableUserAccountRequest] ドキュメントを作成する
  Future<void> createDisableUserAccountRequest({required String userId}) async {
    
  }
}
