import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../disable_user_account_request.dart';

final disableUserAccountRequestControllerProvider =
    Provider.autoDispose<DisableUserAccountRequestController>(
  (ref) => DisableUserAccountRequestController(
    disableUserAccountRequestService:
        ref.watch(disableUserAccountRequestServiceProvider),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class DisableUserAccountRequestController {
  const DisableUserAccountRequestController({
    required DisableUserAccountRequestService disableUserAccountRequestService,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _disableUserAccountRequestService = disableUserAccountRequestService,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final DisableUserAccountRequestService _disableUserAccountRequestService;
  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// ダイアログにより退会確認を行い、退会する場合は[disableUserAccountRequest] ドキュメントを作成する
  //TODO　必要なら [AuthService] の [logout] メソッドをコールする
  Future<void> disableUserAccountRequest({required String userId}) async {
    await _appScaffoldMessengerController.showDialogByBuilder<void>(
      builder: (context) => AlertDialog(
        title: const SelectableText('本当に退会しますか？'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                await _disableUserAccountRequestService.disableUserAccount(
                  userId: userId,
                );
                if (!context.mounted) {
                  return;
                }
                Navigator.pop(context);
                await _showDisableUserAccountCompletedDialog();
              } on FirebaseException catch (e) {
                _appScaffoldMessengerController
                    .showSnackBarByFirebaseException(e);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              '退会する',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('戻る'),
          )
        ],
      ),
    );
  }

  /// 退会処理が完了したことをユーザーに通知するダイアログを表示する
  Future<void> _showDisableUserAccountCompletedDialog() async {
    await _appScaffoldMessengerController.showDialogByBuilder<void>(
      builder: (context) => AlertDialog(
        title: const Text('退会処理が完了しました。'),
        content: const Text('ご利用いただきありがとうございました。'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
