import '../firestore_documents/user_social_login.dart';

class UserSocialLoginRepository {
  final _query = UserSocialLoginQuery();

  /// 指定した [UserSocialLogin] を購読する。
  Stream<ReadUserSocialLogin?> subscribeUserSocialLogin({
    required String userId,
  }) =>
      _query.subscribeDocument(userSocialLoginId: userId);

  /// [UserSocialLogin] を作成する。
  ///
  /// ログイン済みのソーシャルログインにかかるプロパティのみ `true` とし、それ以外は `false` で作成する。
  /// 既に [UserSocialLogin] が存在する状態で本処理を実行すると、意図せずにプロパティの値が `false` になるため注意。
  Future<void> setUserSocialLogin({
    required String userId,
    bool? isAppleEnabled,
    bool? isGoogleEnabled,
    bool? isLINEEnabled,
  }) =>
      _query.set(
        userSocialLoginId: userId,
        createUserSocialLogin: CreateUserSocialLogin(
          isAppleEnabled: isAppleEnabled ?? false,
          isGoogleEnabled: isGoogleEnabled ?? false,
          isLINEEnabled: isLINEEnabled ?? false,
        ),
      );

  /// [UserSocialLogin] の `isAppleEnabled` を引数で受けた値に更新する。
  Future<void> updateIsAppleEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        userSocialLoginId: userId,
        updateUserSocialLogin: UpdateUserSocialLogin(
          isAppleEnabled: value,
        ),
      );

  /// [UserSocialLogin]の `isGoogleEnabled` を引数で受けた値に更新する。
  Future<void> updateIsGoogleEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        userSocialLoginId: userId,
        updateUserSocialLogin: UpdateUserSocialLogin(
          isGoogleEnabled: value,
        ),
      );

}
