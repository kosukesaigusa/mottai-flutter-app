import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/auth.dart';
import '../../../auth/ui/sign_in_buttons.dart';
import '../../../chat/ui/chat_room.dart';
import '../../../force_update/ui/force_update.dart';
import '../../../job/ui/job_detail.dart';
import '../../../map/ui/map.dart';
import '../../../scaffold_messenger_controller.dart';
import '../../../user/user.dart';
import '../../../user/user_mode.dart';
import '../../color/ui/color.dart';
import '../../generic_image/generic_image.dart';
import '../../image_detail_view/image_detail_view_stub.dart';
import '../../image_picker/ui/image_picker_sample.dart';
import '../../sample_todo/ui/sample_todos.dart';

/// 開発中の各ページへの導線を表示するページ。
class DevelopmentItemsPage extends ConsumerWidget {
  const DevelopmentItemsPage({super.key});

  static const path = '/developmentItems';
  static const name = 'DevelopmentItemsPage';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開発ページ'),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(appScaffoldMessengerControllerProvider)
                .showSnackBar('SnackBar を表示します。'),
            icon: const Icon(Icons.notifications_on),
          )
        ],
      ),
      drawer: const Drawer(child: _DrawerChild()),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '主要なページ・機能（実際のディレクトリを lib 以下に作成）',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text(
              'マップページ (geoflutterfire_plus, flutter_google_maps, '
              'geolocator, PageView)',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const MapPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('仕事詳細ページ (FutureProvider)'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const JobDetailPage(),
              ),
            ),
          ),
          const ListTile(
            title: Text('チャットルーム一覧ページ（StreamProvider、未既読管理）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          ListTile(
            title: const Text(
              'チャットルームページ（AsyncNotifier, リアルタイムチャット、無限スクロール、チャット送信、未既読管理）',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ChatRoomPage(),
              ),
            ),
          ),
          const ListTile(
            title: Text('ユーザー詳細ページ（ワーカー）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('ユーザー情報編集ページ（ワーカー）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text(
              'ホストとして登録ページ (Notifier, geoflutterfire_plus, '
              'flutter_google_maps, geolocator)',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('ユーザー詳細ページ（ホスト）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('ユーザー情報編集ページ（ホスト）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '各機能の実装（UI は lib/development 以下に仮実装。その他のモジュールなどは適切な場所に実装）',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('画像選択・圧縮（1 枚 or 複数）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ImagePickSample(),
              ),
            ),
          ),
          const ListTile(
            title: Text('画像アップロード'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('強制アップデート'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('レビュー中管理'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          ListTile(
            title: const Text('サインイン (Google, Apple)'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const GoogleAppleSignin(),
              ),
            ),
          ),
          const ListTile(
            title: Text('サインイン (LINE, Firebase Functions)'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text('FCM トークン（トークン追加, device_info_plus）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          const ListTile(
            title: Text(
              '通知 (firebase_messaging, local_notification, dynamic_links)',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
          ),
          ListTile(
            title: const Text('Components'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const GenericImages(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              '画像の詳細拡大画面サンプル',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ImageDetailViewStubPage(),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'まだ着手しない or 検討中機能',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const ListTile(
            title: Text(
              'ルーティング (auto_route, BottomNavigationBar, AuthGuard、権限管理)',
            ),
          ),
          const ListTile(title: Text('Security Rules')),
          const ListTile(title: Text('ホスト運営登録承認')),
          const ListTile(title: Text('お問い合わせ')),
          const ListTile(title: Text('不適切 UGC の通報 or 非表示')),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'サンプル',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text(
              'Todo 一覧ページ',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const SampleTodosPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              '色の確認',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ColorPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'forceUpdateページ',
            ),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ForceUpdatePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerChild extends ConsumerStatefulWidget {
  const _DrawerChild();

  @override
  ConsumerState<_DrawerChild> createState() => _DrawerChildState();
}

class _DrawerChildState extends ConsumerState<_DrawerChild> {
  late final TextEditingController _emailTextEditingController;
  late final TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('mottai-app-dev'),
              if (ref.watch(isHostProvider)) ...[
                const Gap(8),
                Text(
                  'ユーザーモード',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                ToggleButtons(
                  onPressed: (index) {
                    final notifier = ref.read(userModeStateProvider.notifier);
                    if (index == 0) {
                      notifier.update((_) => UserMode.worker);
                    } else if (index == 1) {
                      notifier.update((_) => UserMode.host);
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  constraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 80,
                  ),
                  isSelected: UserMode.values
                      .map((mode) => mode == ref.watch(userModeStateProvider))
                      .toList(),
                  children: UserMode.values
                      .map((userMode) => Text(userMode.name))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ref.watch(isSignedInProvider)) ...[
                Text(
                  'ユーザー ID',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Gap(8),
                Text(ref.watch(userIdProvider)!),
                const Gap(16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await ref.read(authServiceProvider).signOut();
                      navigator.pop();
                    },
                    child: const Text('サインアウト'),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _emailTextEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'メールアドレス',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(16),
                TextField(
                  controller: _passwordTextEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'パスワード',
                  ),
                  obscureText: true,
                ),
                const Gap(16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await ref
                          .read(authServiceProvider)
                          .signInWithEmailAndPassword(
                            email: _emailTextEditingController.text,
                            password: _passwordTextEditingController.text,
                          );
                      navigator.pop();
                    },
                    child: const Text('サインイン'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
