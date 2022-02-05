import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/services/shared_preferences_service.dart';

import '../../controllers/account/account_page_controller.dart';
import '../../utils/utils.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const path = '/account/';
  static const name = 'AccountPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('AccountPage'),
            const Gap(8),
            DocumentFutureBuilder<String>(
              future: SharedPreferencesService.getProfileImageURL(),
              waitingWidget: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
              noDataWidget: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 36,
                ),
              ),
              builder: (context, url) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(),
                );
              },
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: () async {
                await ref.read(accountPageController.notifier).signInWithGoogle();
              },
              child: const Text('Google でサインイン'),
            ),
            const Gap(8),
            if (auth.currentUser != null)
              Text('ログイン済み ID: ${nonNullUid.substring(0, 10)}...')
            else
              const Text('ログインしていません。'),
          ],
        ),
      ),
    );
  }
}
