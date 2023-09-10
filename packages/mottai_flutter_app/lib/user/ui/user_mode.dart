import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../scaffold_messenger_controller.dart';
import '../user_mode.dart';

/// ワーカーページ、ホストページなどで使用する、[UserMode] を選択する [Section].
class UserModeSection extends ConsumerWidget {
  const UserModeSection({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMode = ref.watch(userModeStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Section(
          titleBottomMargin: 8,
          title: 'ユーザーモード',
          titleStyle: Theme.of(context).textTheme.titleLarge,
          content: Text(_userModeDescription(userMode)),
        ),
        const Gap(8),
        SegmentedButton<UserMode>(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          segments: const <ButtonSegment<UserMode>>[
            ButtonSegment<UserMode>(
              value: UserMode.host,
              label: Text('ホスト'),
            ),
            ButtonSegment<UserMode>(
              value: UserMode.worker,
              label: Text('ワーカー'),
            ),
          ],
          selected: <UserMode>{userMode},
          onSelectionChanged: (newSelection) {
            ref
                .read(userModeStateProvider.notifier)
                .update((_) => newSelection.first);
            ref
                .read(appScaffoldMessengerControllerProvider)
                .showSnackBar('${newSelection.first.label}に切り替えました。');
          },
        )
      ],
    );
  }
}

String _userModeDescription(UserMode userMode) {
  switch (userMode) {
    case UserMode.worker:
      return 'ワーカーとしてアプリを使用します。'
          '興味のあるホストやお手伝いを探して、お手伝いに応募するモードです。';
    case UserMode.host:
      return 'ホストとしてアプリを使用します。'
          'あなたが募集するお手伝いに興味があるワーカーとやりとりをして、'
          'お手伝いを受け入れるモードです。';
  }
}
