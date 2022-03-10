import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';

import '../../controllers/account/account_page_controller.dart';
import '../../controllers/scaffold_messenger/scaffold_messenger_controller.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/utils.dart';
import '../../widgets/common/loading.dart';

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
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.google),
            onPressed: () async {
              await ref.read(accountPageController.notifier).signInWithGoogle();
            },
            label: const Text('Google でサインイン'),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.apple),
            onPressed: () async {
              await ref.read(accountPageController.notifier).signInWithApple();
            },
            label: const Text('Apple でサインイン'),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ElevatedButton.icon(
            icon: const FaIcon(FontAwesomeIcons.line),
            onPressed: () async {
              await ref.read(accountPageController.notifier).signInWithLine();
            },
            label: const Text('LINE でサインイン'),
          ),
        ),
        const Gap(16),
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
