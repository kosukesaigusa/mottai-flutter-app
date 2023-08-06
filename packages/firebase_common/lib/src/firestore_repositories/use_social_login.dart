import '../firestore_documents/user_social_login.dart';

class UserSocialLoginRepository {
  final _query = UserSocialLoginQuery();

  /// 指定した [UserSocialLogin] を購読する。
  Stream<ReadUserSocialLogin?> subscribeWorker({required String userId}) =>
      _query.subscribeDocument(userSocialLoginId: userId);

  /// いずれかのソーシャルログインが初めて行われた際に、 [UserSocialLogin] を作成する。
  /// 
  /// そのソーシャルログインにかかるプロパティのみ `true` とし、それ以外は `false` で作成する。
  /// [UserSocialLogin] が既に存在する状態で実行すると、意図せずにプロパティの値が `false` になる可能性があるため注意すること。
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

  /// [UserSocialLogin]の `isLINEEnabled` を引数で受けた値に更新する。
  Future<void> updateIsLINEEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        userSocialLoginId: userId,
        updateUserSocialLogin: UpdateUserSocialLogin(
          isLINEEnabled: value,
        ),
      );
}
