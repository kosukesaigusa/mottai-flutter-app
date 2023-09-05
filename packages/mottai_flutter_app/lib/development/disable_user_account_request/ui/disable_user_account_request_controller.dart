import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';

final disableUserAccountRequestControllerProvider =
    Provider.autoDispose<DisableUserAccountRequestController>(
  (ref) => DisableUserAccountRequestController(
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class DisableUserAccountRequestController {
  const DisableUserAccountRequestController({
    required AppScaffoldMessengerController appScaffoldMessengerController,
  }) : _appScaffoldMessengerController = appScaffoldMessengerController;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// ダイアログにより退会確認を行い、退会する場合は[disableUserAccountRequest] ドキュメントを作成する
  //TODO　必要なら [AuthService] の [logout] メソッドをコールする
  Future<void> disableUserAccountRequest() async {
    await _appScaffoldMessengerController.showDialogByBuilder<void>(
      builder: (context) => AlertDialog(
        title: const SelectableText('本当に退会しますか？'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _createDisableUserAccountRequest();
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

  Future<void> _createDisableUserAccountRequest() async {
    //TODO
  }
}
