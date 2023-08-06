import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/auth.dart';
import '../../../chat/ui/chat_room.dart';
import '../../../chat/ui/chat_rooms.dart';
import '../../../job/ui/job_detail.dart';
import '../../../map/ui/map.dart';
import '../../../package_info.dart';
import '../../../push_notification/firebase_messaging.dart';
import '../../../scaffold_messenger_controller.dart';
import '../../../user/user.dart';
import '../../../user/user_mode.dart';
import '../../color/ui/color.dart';
import '../../force_update/ui/force_update.dart';
import '../../generic_image/ui/generic_images.dart';
import '../../image_detail_view/ui/image_detail_view_stub.dart';
import '../../image_picker/ui/image_picker_sample.dart';
import '../../in_review/ui/in_review.dart';
import '../../sample_todo/ui/sample_todos.dart';
import '../../sign_in/ui/sign_in.dart';
import '../../web_link/ui/web_link_stub.dart';

/// 開発中の各ページへの導線を表示するページ。
@RoutePage()
class DevelopmentItemsPage extends StatefulHookConsumerWidget {
  const DevelopmentItemsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/developmentItems';

  /// [DevelopmentItemsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<DevelopmentItemsPage> createState() =>
      _DevelopmentItemsPageState();
}

class _DevelopmentItemsPageState extends ConsumerState<DevelopmentItemsPage> {
  @override
  void initState() {
    super.initState();
    Future.wait<void>([
      ref.read(initializeFirebaseMessagingProvider)(),
      ref.read(getFcmTokenProvider)(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => context.router.pushNamed(MapPage.location),
          ),
          ListTile(
            title: const Text('仕事詳細ページ (FutureProvider)'),
            onTap: () => context.router.pushNamed(
              JobDetailPage.location(jobId: 'PYRsrMSOApEgZ6lzMuUK'),
            ),
          ),
          ListTile(
            title: const Text('チャットルーム一覧ページ（StreamProvider、未既読管理）'),
            onTap: () => context.router.pushNamed(ChatRoomsPage.location),
          ),
          ListTile(
            title: const Text(
              'チャットルームページ（AsyncNotifier, リアルタイムチャット、無限スクロール、チャット送信、未既読管理）',
            ),
            onTap: () => context.router.pushNamed(
              ChatRoomPage.location(chatRoomId: 'aSNYpkUofu05nyasvMRx'),
            ),
          ),
          const ListTile(
            title: Text('ワーカーページ'),
            // onTap: () => context.router.pushNamed(
            //   WorkerPage.location('WORKER_ID_HERE'),
            // ),
          ),
          const ListTile(
            title: Text('ワーカー情報編集ページ'),
            // onTap: () => context.router.pushNamed(
            //   UpdateWorkerPage.location('WORKER_ID_HERE'),
            // ),
          ),
          const ListTile(
            title: Text('ホストページ'),
            // onTap: () => context.router.pushNamed(
            //   HOSTPage.location('HOST_ID_HERE'),
            // ),
          ),
          const ListTile(
            title: Text(
              'ホストとして登録ページ (StateNotifier?, geoflutterfire_plus, '
              'flutter_google_maps, geolocator)',
            ),
            // onTap: () => context.router.pushNamed(
            //   CreateOrUpdateHostPage.location('HOST_ID_HERE'),
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
            onTap: () =>
                context.router.pushNamed(ImagePickerSamplePage.location),
          ),
          const ListTile(
            title: Text('画像アップロード'),
            // onTap: () =>
            //     context.router.pushNamed(FirebaseStorageSamplePage.location),
          ),
          ListTile(
            title: const Text('強制アップデート'),
            onTap: () =>
                context.router.pushNamed(ForceUpdateSamplePage.location),
          ),
          ListTile(
            title: const Text('レビュー中かどうか'),
            onTap: () => context.router.pushNamed(InReviewPage.location),
          ),
          ListTile(
            title: const Text('サインイン (Google, Apple, LINE)'),
            onTap: () => context.router.pushNamed(SignInSamplePage.location),
          ),
          const ListTile(
            title: Text('FCM トークン（トークン追加, device_info_plus）'),
            // onTap: () => context.router.pushNamed(FcmTokenPage.location),
          ),
          const ListTile(
            title: Text(
              '通知 (firebase_messaging, local_notification, dynamic_links)',
            ),
            // onTap: () =>
            //     context.router.pushNamed(FirebaseMessagingPage.location),
          ),
          ListTile(
            title: const Text('汎用画像ウィジェット'),
            onTap: () => context.router.pushNamed(GenericImagesPage.location),
          ),
          ListTile(
            title: const Text(
              '画像の詳細拡大画面サンプル',
            ),
            onTap: () =>
                context.router.pushNamed(ImageDetailViewStubPage.location),
          ),
          ListTile(
            title: const Text(
              'WebLinkサンプル',
            ),
            onTap: () => context.router.pushNamed(WebLinkStubPage.location),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'まだ着手しない or 検討中機能',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const ListTile(title: Text('Security Rules')),
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
            onTap: () => context.router.pushNamed(SampleTodosPage.location),
          ),
          ListTile(
            title: const Text(
              '色の確認',
            ),
            onTap: () => context.router.pushNamed(ColorPage.location),
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
    final packageInfo = ref.watch(packageInfoProvider);
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(packageInfo.packageName),
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
