import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app/theme/theme.dart';
import 'package:mottai_flutter_app/utils/enums.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
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
      ),
    );
  }

  /// 未ログイン時のウィジェット
  Widget _buildNotSignedInWidget(WidgetRef ref) {
    return Column(
      children: [
        _buildSocialLoginButtons,
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
        const Gap(8),
        ElevatedButton.icon(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            await auth.signOut();
            ref.read(scaffoldMessengerController).showSnackBar('サインアウトしました。');
          },
          label: const Text('サインアウトする'),
        ),
        const Gap(16),
        Row(children: [
          const Expanded(child: Divider()),
          const Gap(16),
          Text('他のログイン方法と連携する', style: grey12),
          const Gap(16),
          const Expanded(child: Divider()),
        ]),
        const Gap(16),
        StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            return _buildSocialLoginButtons;
          },
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
        return Column(
          children: [
            Text('こんにちは、$fullName さん。'),
            _buildConnectedSocialAccounts,
          ],
        );
      },
    );
  }

  /// 連携済みのソーシャルアカウントの種類 (providerId) を返す
  List<String> get _linkedSocialAccounts {
    final user = auth.currentUser;
    if (user == null) {
      return [];
    }
    return user.providerData.map((userInfo) => userInfo.providerId).toList();
  }

  /// 連携済みソーシャルログインのカラムを返す
  Widget get _buildConnectedSocialAccounts {
    return Column(
      children: [
        if (_linkedSocialAccounts.contains('google.com')) ...[
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(
                FontAwesomeIcons.google,
                size: 12,
                color: Color(0xff3369E8),
              ),
              Gap(8),
              Text(
                'Google 連携済み',
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
              ),
            ],
          ),
        ],
        if (_linkedSocialAccounts.contains('apple.com')) ...[
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(
                FontAwesomeIcons.apple,
                size: 12,
                color: Color(0xff3369E8),
              ),
              Gap(8),
              Text(
                'Apple 連携済み',
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// ソーシャルログインボタンのカラムを返す
  Widget get _buildSocialLoginButtons {
    return Column(
      children: [
        if (!_linkedSocialAccounts.contains('google.com')) ...[
          const SocialSignInButton(SocialSignInMethod.Google),
          const Gap(8),
        ],
        if (!_linkedSocialAccounts.contains('apple.com')) ...[
          const SocialSignInButton(SocialSignInMethod.Apple),
          const Gap(8),
        ],
        const SocialSignInButton(SocialSignInMethod.LINE),
      ],
    );
  }
}
