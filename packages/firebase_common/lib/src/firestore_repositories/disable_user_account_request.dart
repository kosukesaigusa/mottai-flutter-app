import '../firestore_documents/disable_user_account_request.dart';

class DisableUserAccountRequestRepository {
  final _query = DisableUserAccountRequestQuery();

  /// [DisableUserAccountRequest] を作成する。
  Future<void> setDisableUserAccountRequest({
    required String userId,
  }) =>
      _query.set(
        disableUserAccountRequestId: userId,
        createDisableUserAccountRequest: CreateDisableUserAccountRequest(
          userId: userId,
        ),
      );

}
