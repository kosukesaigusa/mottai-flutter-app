import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/utils/enums.dart';

import '../../controllers/account/account_page_controller.dart';
import '../../controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/loading.dart';
import '../../widgets/sign_in/sign_in_buttons.dart';

const double buttonHeight = 48;
const double buttonWidth = 240;

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
            const Gap(16),
            StreamBuilder<User?>(
              stream: auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PrimarySpinkitCircle();
                }
                if (!snapshot.hasData) {
                  return _buildNotSignedInWidget(ref);
                }
                return _buildSignedInWidget(ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 未ログイン時のウィジェット
  Widget _buildNotSignedInWidget(WidgetRef ref) {
    return Column(
      children: [
        SocialSignInButton<void>(
          method: SocialSignInMethod.Google,
          onPressed: ref.read(accountPageController.notifier).signInWithGoogle,
          innerPadding: const EdgeInsets.all(0),
        ),
        const Gap(8),
        SocialSignInButton<void>(
          method: SocialSignInMethod.Apple,
          onPressed: ref.read(accountPageController.notifier).signInWithApple,
        ),
        const Gap(8),
        SocialSignInButton<void>(
          method: SocialSignInMethod.LINE,
          onPressed: ref.read(accountPageController.notifier).signInWithLine,
        ),
        const Gap(8),
        const Text('ログインしていません。'),
      ],
    );
  }

  /// ログイン済みのウィジェット
  Widget _buildSignedInWidget(WidgetRef ref) {
    return Column(
      children: [
        _buildProfileImageWidget,
        const Gap(16),
        _buildDisplayNameWidget,
        const Gap(16),
        ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            await auth.signOut();
            ref.read(scaffoldMessengerController).showSnackBar('サインアウトしました。');
          },
          label: const Text('サインアウトする'),
        ),
      ],
    );
  }

  /// プロフィール画像のウィジェット
  Widget get _buildProfileImageWidget {
    return DocumentFutureBuilder<String>(
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
        return CircleImage(
          radius: 64,
          imageURL: url,
        );
      },
    );
  }

  /// 表示名のウィジェット
  Widget get _buildDisplayNameWidget {
    return DocumentFutureBuilder<String>(
      future: SharedPreferencesService.getDisplayName(),
      builder: (context, fullName) {
        if (fullName.trim().isEmpty) {
          return const Text('ログイン済みです。');
        }
        return Text('こんにちは、$fullName さん');
      },
    );
  }
}
