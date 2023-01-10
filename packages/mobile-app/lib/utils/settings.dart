// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';

// /// Dart Define で定義した flavor 文字列。
// const flavorString = String.fromEnvironment('FLAVOR');

// /// Dart Define で定義した GitHub のパーソナルトークン。
// const gitHubToken = String.fromEnvironment('GITHUB_TOKEN');

// /// dart-define で設定した flavor 文字列から特定される Flavor 変数。
// /// Provider を使用しても良いが、、グローバルな変数とすることにした。
// final flavor = Flavor.values.firstWhere((f) => f.name == flavorString);

// /// Flutter のビルドオプションの flavor
// enum Flavor {
//   local,
//   dev;

//   const Flavor();

//   /// 接続先 Firebase プロジェクト。
//   /// このアプリはハッカソン向けのため、flavor ごとの Firebase プロジェクトの向き先変更は行っていない。
//   FirebaseOptions get firebaseOptions => DefaultFirebaseOptions.currentPlatform;

//   /// Android で foreground で通知を受け取ったときの通知アイコン。
//   String get androidForegroundNotificationIcon {
//     switch (this) {
//       // Note: このような画像ファイル名にハイフンは使用できない。
//       case dev:
//       case local:
//         return '@drawable/transparent_notification_icon';
//     }
//   }
// }
