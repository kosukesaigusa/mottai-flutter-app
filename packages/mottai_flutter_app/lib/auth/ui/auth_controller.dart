import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../auth.dart';

final authControllerProvider =
    Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _authService = authService,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final AuthService _authService;
  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// OAuthを使用したサインイン
  Future<void> signInOauth(Authenticator authenticator) async {
    switch(authenticator){
      // Googleアカウントを使用したログイン処理の場合
      case Authenticator.google:
        try{
          final googleUser = await GoogleSignIn().signIn();     // サインインダイアログの表示
          final googleAuth = await googleUser?.authentication;  // アカウントからトークン生成
          if(googleAuth != null){
            await _authService.signInWithGoogle(googleAuth: googleAuth);
            return ;
          }
        }
        // キャンセル時
        on PlatformException catch(e){
          if(e.code == 'network_error'){
            // ネットワークエラー
            _appScaffoldMessengerController
                .showSnackBar('接続できませんでした。\nネットワーク状況を確認してください。');
          }
          return ;
        }

      case Authenticator.apple:
        try{
          await _authService.signInWithApple();
        }
        // キャンセル時
        on FirebaseAuthException catch(_){
          // Appleはネットワークエラーとキャンセル時の判断ができないため、スナックバーは表示しない
          return ;
        }
        return ;

      default:
        break;
    }
    return ;
  }



}
