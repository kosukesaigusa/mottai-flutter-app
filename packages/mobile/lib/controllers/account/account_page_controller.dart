import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/services/shared_preferences_service.dart';

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
      final photoUrl = googleSignInAccount.photoUrl;
      if (photoUrl != null) {
        await SharedPreferencesService.sp.setString(
          SharedPreferencesKey.profileImageURL.name,
          photoUrl,
        );
      }
      _reader(scaffoldMessengerController).showSnackBar('サインインしました。');
      return;
    } on PlatformException catch (e) {
      _reader(scaffoldMessengerController).showSnackBar('[${e.code}] キャンセルしました。');
    }
    return;
  }
}
