import 'package:flutter/material.dart';

/// 開発中の各ページへの導線を表示するページ。
class DevelopmentItemsPage extends StatelessWidget {
  const DevelopmentItemsPage({super.key});

  static const path = '/developmentItems';
  static const name = 'DevelopmentItemsPage';
  static const location = path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('開発ページ'),
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '主要なページ・機能（実際のディレクトリを lib 以下に作成）',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const ListTile(
            title: Text(
              'マップページ (geoflutterfire_plus, flutter_google_maps, '
              'geolocator, PageView)',
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
            title: Text('仕事詳細ページ (FutureProvider)'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
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
          const ListTile(
            title: Text(
              'チャットルームページ（AsyncNotifier, リアルタイムチャット、無限スクロール、チャット送信、未既読管理）',
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
          const ListTile(
            title: Text('画像選択・圧縮（1 枚 or 複数）'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
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
          const ListTile(
            title: Text('サインイン (Google, Apple)'),
            // TODO: 後に auto_route を採用して Navigator.pushNamed を使用する予定
            // onTap: () => Navigator.push<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (context) => FooPage(),
            //   ),
            // ),
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
        ],
      ),
    );
  }
}
