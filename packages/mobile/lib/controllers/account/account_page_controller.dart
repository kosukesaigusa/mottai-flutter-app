import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/services/shared_preferences_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../utils/enums.dart';
import '../scaffold_messenger/scaffold_messenger_controller.dart';
import 'account_page_state.dart';

final accountPageController = StateNotifierProvider<AccountPageController, AccountPageState>(
  (ref) => AccountPageController(ref.read),
);

class AccountPageController extends StateNotifier<AccountPageState> {
  AccountPageController(this._reader) : super(const AccountPageState());

  final Reader _reader;

  /// Google でサインインして、SharedPreferences に画像や名前を保存する。
  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        _reader(scaffoldMessengerController).showSnackBar('サインインに失敗しました。');
        return;
      }
      final googleSignInAuthentication = await googleSignInAccount.authentication;
      final oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      await _storeUserProfileInSharedPreferences(
        signInMethod: SignInMethodEnum.google,
        photoUrl: googleSignInAccount.photoUrl,
        displayName: googleSignInAccount.displayName,
      );
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
  }

  /// Apple でサインインして、SharedPreferences に名前を保存する。
  Future<void> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    try {
      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: authorizationCredentialAppleID.identityToken,
        rawNonce: rawNonce,
      );
      await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      final currentAppleIdUserIdentifier =
          SharedPreferencesService.sp.getString(SharedPreferencesKey.appleIdUserIdentifier.name);
      final newAppleIdUserIdentifier = authorizationCredentialAppleID.userIdentifier;
      // Apple ID の userIdentifier が変わった時だけ SharedPreferences を上書きする
      if (currentAppleIdUserIdentifier != newAppleIdUserIdentifier &&
          newAppleIdUserIdentifier != null) {
        await _storeUserProfileInSharedPreferences(
          signInMethod: SignInMethodEnum.apple,
          displayName: "${authorizationCredentialAppleID.familyName ?? ''} "
              "${authorizationCredentialAppleID.givenName ?? ''}",
          appleIdUserIdentifier: authorizationCredentialAppleID.userIdentifier,
        );
      }
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
      return;
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
    return;
  }

  /// SharedPreferences に画像と表示名を保存する
  Future<void> _storeUserProfileInSharedPreferences({
    required SignInMethodEnum signInMethod,
    String? photoUrl,
    String? displayName,
    String? appleIdUserIdentifier,
  }) async {
    await SharedPreferencesService.sp.setString(
      SharedPreferencesKey.lastSignedInMethod.name,
      signInMethod.name,
    );
    if (photoUrl != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.profileImageURL.name,
        photoUrl,
      );
    }
    if (displayName != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.displayName.name,
        displayName,
      );
    }
    if (appleIdUserIdentifier != null) {
      await SharedPreferencesService.sp.setString(
        SharedPreferencesKey.appleIdUserIdentifier.name,
        appleIdUserIdentifier,
      );
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
