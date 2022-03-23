import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/providers/account/account_providers.dart';
import 'package:mottai_flutter_app/providers/auth/auth_providers.dart';
import 'package:mottai_flutter_app/utils/utils.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../repository/auth/auth_repository.dart';
import '../../utils/enums.dart';

final authService = Provider.autoDispose((ref) => AuthService(ref.read));

/// 主にサインインをするための、ビューコントローラとリポジトリの間に立つクラス。
/// つまりビューコントローラはこのサービスクラスとだけやり取りをする。
/// このサービスクラスは AuthRepository とやり取りをしたり、
/// 必要によっては SharedPreferencesService とやり取りをしたりして、
/// 結果をコントローラに返す。
/// クラス名はこれが最適かどうかは確信がない。
class AuthService {
  AuthService(this._read);
  final Reader _read;

  Future<void> signIn(SocialSignInMethod method) async {
    try {
      AuthResult? result;
      if (method == SocialSignInMethod.Google) {
        result = await signInWithGoogle();
      } else if (method == SocialSignInMethod.Apple) {
        result = await signInWithApple();
      } else if (method == SocialSignInMethod.LINE) {
        result = await signInWithLINE();
      }
      final userCredential = result?.userCredential;
      if (userCredential == null) {
        throw Exception();
      }
      // Firestore にデータを保存する
      await _updateAccount(
        method: method,
        displayName: result?.displayName,
        imageURL: result?.imageURL,
      );
    } on PlatformException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// Google でサインインする。
  Future<AuthResult?> signInWithGoogle() async {
    try {
      final result = await _read(authRepository).signInWithGoogle();
      return result;
    } on PlatformException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  // Apple でサインインする。
  Future<AuthResult?> signInWithApple() async {
    try {
      final result = await _read(authRepository).signInWithApple();
      return result;
    } on PlatformException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  // LINE でサインインする。
  Future<AuthResult?> signInWithLINE() async {
    try {
      final result = await _read(authRepository).signInWithLINE();
      return result;
    } on PlatformException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// サインアウトする。
  Future<void> signOut() async {
    try {
      await _read(authRepository).signOut();
    } on PlatformException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// Firestore の Account ドキュメントを set or update する
  Future<void> _updateAccount({
    required SocialSignInMethod method,
    String? displayName,
    String? imageURL,
  }) async {
    // final account = _read(accountFutureProvider).value;
    final userId = _read(userIdProvider).value;
    if (userId == null) {
      return;
    }
    final account = await AccountRepository.fetchAccount(accountId: userId);
    try {
      if (account != null) {
        // すでにドキュメントが存在しているので update する
        // displayName, imageURL のフィールドについては現在保存されている値が
        // null の場合のみ更新する（意味のある値が保存されいてる場合は上書きしない）
        await _read(accountRefProvider).update(
          processMapToUpdateFirestoreDoc(<String, dynamic>{
            'displayName': account.displayName == null ? displayName : null,
            'imageURL': account.imageURL == null ? imageURL : null,
            'providers': FieldValue.arrayUnion(<String>[method.name]),
            'updatedAt': FieldValue.serverTimestamp(),
          }),
        );
      } else {
        await _read(accountRefProvider).set(Account(
          accountId: nonNullUid,
          displayName: displayName,
          imageURL: imageURL,
          providers: <String>[method.name],
        ));
      }
    } on FirebaseException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  /// SharedPreferences に ... を保存する
}
