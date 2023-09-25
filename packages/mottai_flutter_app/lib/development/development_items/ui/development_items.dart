import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_dependent_builder.dart';
import '../../../chat/read_status.dart';
import '../../../chat/ui/chat_room.dart';
import '../../../chat/ui/chat_rooms.dart';
import '../../../host/ui/host.dart';
import '../../../host/ui/host_create.dart';
import '../../../host/ui/host_update.dart';
import '../../../job/ui/job_create.dart';
import '../../../job/ui/job_detail.dart';
import '../../../job/ui/job_update.dart';
import '../../../map/ui/map.dart';
import '../../../worker/ui/worker.dart';
import '../../color/ui/color.dart';
import '../../firebase_messaging/ui/firebase_messaging.dart';
import '../../firebase_storage/ui/firebase_storage.dart';
import '../../generic_image/ui/generic_images.dart';
import '../../geoflutterfire_plus/geoflutterfire_plus.dart';
import '../../image_detail_view/ui/image_detail_view_stub.dart';
import '../../image_picker/ui/image_picker_sample.dart';
import '../../in_review/ui/in_review.dart';
import '../../review/review_create.dart';
import '../../sample_todo/ui/todos.dart';
import '../../sign_in/ui/sign_in.dart';
import '../../user_fcm_token/ui/user_fcm_token.dart';
import '../../user_generate_content/ui/user_generate_content_sample.dart';
import '../../user_social_login/user_social_login.dart';
import '../../web_link/ui/web_link_stub.dart';

/// 開発中の各ページへの導線を表示するページ。
@RoutePage()
class DevelopmentItemsPage extends ConsumerWidget {
  const DevelopmentItemsPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/developmentItems';

  /// [DevelopmentItemsPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('開発ページ')),
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
            title: const Text('仕事情報作成ページ'),
            onTap: () => context.router.pushNamed(JobCreatePage.location),
          ),
          ListTile(
            title: const Text('仕事情報編集ページ'),
            onTap: () => context.router.pushNamed(
              JobUpdatePage.location(jobId: 'PYRsrMSOApEgZ6lzMuUK'),
            ),
          ),
          ListTile(
            title: const Text('チャットルーム一覧ページ（StreamProvider、未既読管理）'),
            onTap: () => context.router.pushNamed(ChatRoomsPage.location),
          ),
          AuthDependentBuilder(
            onAuthenticated: (userId) {
              return ListTile(
                title: const Text(
                  'チャットルームページ（AsyncNotifier, リアルタイムチャット、無限スクロール、チャット送信、未既読管理）',
                ),
                onTap: () async {
                  const chatRoomId = 'aSNYpkUofu05nyasvMRx';
                  await context.router.pushNamed(
                    ChatRoomPage.location(chatRoomId: chatRoomId),
                  );
                  await ref
                      .read(readStatusServiceProvider)
                      .setReadStatus(chatRoomId: chatRoomId, userId: userId);
                },
              );
            },
            onUnAuthenticated: () => const ListTile(
              title: Text(
                'チャットルームページ（ログインしないと使えません）',
              ),
            ),
          ),
          ListTile(
            title: const Text('ワーカーページ'),
            onTap: () => context.router.pushNamed(
              WorkerPage.location(userId: 'b1M4bcp7zEVpgHXYhOVWt8BMkq23'),
            ),
          ),
          const ListTile(
            title: Text('ワーカー情報編集ページ'),
            // onTap: () => context.router.pushNamed(
            //   UpdateWorkerPage.location('WORKER_ID_HERE'),
            // ),
          ),
          ListTile(
            title: const Text('ホストページ'),
            onTap: () => context.router.pushNamed(
              HostPage.location(userId: 'b1M4bcp7zEVpgHXYhOVWt8BMkq23'),
            ),
          ),
          ListTile(
            title: const Text(
              'ホストとして登録ページ (StateNotifier?, geoflutterfire_plus, '
              'flutter_google_maps, geolocator)',
            ),
            onTap: () => context.router.pushNamed(
              HostCreatePage.location,
            ),
          ),
          ListTile(
            title: const Text(
              'ホスト情報更新ページ',
            ),
            onTap: () => context.router.pushNamed(
              HostUpdatePage.location(hostId: 'b1M4bcp7zEVpgHXYhOVWt8BMkq23'),
            ),
          ),
          ListTile(
            title: const Text(
              '感想投稿ページ',
            ),
            onTap: () => context.router.pushNamed(
              ReviewCreatePage.location(jobId: 'PYRsrMSOApEgZ6lzMuUK'),
            ),
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
          ListTile(
            title: const Text('画像アップロード'),
            onTap: () =>
                context.router.pushNamed(FirebaseStorageSamplePage.location),
          ),
          ListTile(
            title: const Text('レビュー中かどうか'),
            onTap: () => context.router.pushNamed(InReviewPage.location),
          ),
          ListTile(
            title: const Text('サインイン (Google, Apple, LINE)'),
            onTap: () => context.router.pushNamed(SignInSamplePage.location),
          ),
          ListTile(
            title: const Text('ソーシャル認証連携 (Google, Apple)'),
            onTap: () =>
                context.router.pushNamed(UserSocialLoginSamplePage.location),
          ),
          ListTile(
            title: const Text('UserFcmToken 確認ページ'),
            onTap: () => context.router.pushNamed(UserFcmTokenPage.location),
          ),
          ListTile(
            title: const Text(
              '通知 (firebase_messaging, local_notification, dynamic_links)',
            ),
            onTap: () =>
                context.router.pushNamed(FirebaseMessagingPage.location),
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
          ListTile(
            title: const Text('不適切 UGC の通報 or 非表示'),
            onTap: () => context.router.pushNamed(UgcSamplePage.location),
          ),
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
            onTap: () => context.router.pushNamed(TodosPage.location),
          ),
          ListTile(
            title: const Text(
              '色の確認',
            ),
            onTap: () => context.router.pushNamed(ColorPage.location),
          ),
          ListTile(
            title: const Text(
              'geoflutterfire_plus の機能確認',
            ),
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) => const GeoflutterfirePlusSample(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
