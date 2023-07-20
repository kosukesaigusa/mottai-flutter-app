import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authControllerProvider =
    Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
  })  : _authService = authService;

  final AuthService _authService;

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
        on PlatformException catch(e){}

      case Authenticator.apple:
        try{
          await _authService.signInWithApple();
        }
        on FirebaseAuthException catch(e){}
        return ;

      default:
        break;
    }
    return ;
  }



}
