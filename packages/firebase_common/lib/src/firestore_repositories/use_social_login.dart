import '../firestore_documents/use_social_login.dart';

class UseSocialLoginRepository {
  final _query = UseSocialLoginQuery();

  /// 指定した [UseSocialLogin] を購読する。
  Stream<ReadUseSocialLogin?> subscribeWorker({required String userId}) =>
      _query.subscribeDocument(useSocialLoginId: userId);

  /// いずれかのソーシャルログインが初めて行われた際に、 [UseSocialLogin] を作成する。
  /// 
  /// そのソーシャルログインにかかるプロパティのみ `true` とし、それ以外は `false` で作成する。
  /// [UseSocialLogin] が既に存在する状態で実行すると、意図せずにプロパティの値が `false` になる可能性があるため注意すること。
  Future<void> setUseSocialLogin({
    required String userId,
    bool? isAppleEnabled,
    bool? isGoogleEnabled,
    bool? isLINEEnabled,
  }) =>
      _query.set(
        useSocialLoginId: userId,
        createUseSocialLogin: CreateUseSocialLogin(
          isAppleEnabled: isAppleEnabled ?? false,
          isGoogleEnabled: isGoogleEnabled ?? false,
          isLINEEnabled: isLINEEnabled ?? false,
        ),
      );

  /// [UseSocialLogin] の `isAppleEnabled` を引数で受けた値に更新する。
  Future<void> updateIsAppleEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        useSocialLoginId: userId,
        updateUseSocialLogin: UpdateUseSocialLogin(
          isAppleEnabled: value,
        ),
      );

  /// [UseSocialLogin]の `isGoogleEnabled` を引数で受けた値に更新する。
  Future<void> updateIsGoogleEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        useSocialLoginId: userId,
        updateUseSocialLogin: UpdateUseSocialLogin(
          isGoogleEnabled: value,
        ),
      );

  /// [UseSocialLogin]の `isLINEEnabled` を引数で受けた値に更新する。
  Future<void> updateIsLINEEnabled({
    required String userId,
    required bool value,
  }) =>
      _query.update(
        useSocialLoginId: userId,
        updateUseSocialLogin: UpdateUseSocialLogin(
          isLINEEnabled: value,
        ),
      );
}
