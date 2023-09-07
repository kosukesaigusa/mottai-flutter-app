import '../firestore_documents/disable_user_account_request.dart';

class DisableUserAccountRequestRepository {
  final _query = DisableUserAccountRequestsQuery();

  /// [DisableUserAccountRequests] を作成する。
  Future<void> setDisableUserAccountRequest({
    required String userId,
  }) =>
      _query.set(
        disableUserAccountRequestId: userId,
        createDisableUserAccountRequests: CreateDisableUserAccountRequests(
          userId: userId,
        ),
      );

}
