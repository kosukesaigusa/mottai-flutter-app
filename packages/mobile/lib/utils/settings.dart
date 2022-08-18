import 'package:firebase_core/firebase_core.dart';

import 'firebase_options/firebase_options_dev.dart' as dev_options;
import 'firebase_options/firebase_options_prod.dart' as prod_options;

/// dart-define で設定した flavor 文字列。
const flavorString = String.fromEnvironment('FLAVOR');

/// dart-define で設定した flavor 文字列から特定される Flavor 変数。
/// Provider を使用しても良いが、、グローバルな変数とすることにした。
final flavor = Flavor.values.firstWhere((f) => f.name == flavorString);

/// Flutter のビルドオプションの flavor
enum Flavor {
  local,
  dev,
  prod;

  const Flavor();

  /// 接続先 Firebase プロジェクト。
  FirebaseOptions get firebaseOptions {
    switch (this) {
      case prod:
        return prod_options.DefaultFirebaseOptions.currentPlatform;
      case dev:
      case local:
        return dev_options.DefaultFirebaseOptions.currentPlatform;
    }
  }

  /// Android で foreground で通知を受け取ったときの通知アイコン。
  String get androidForegroundNotificationIcon {
    switch (this) {
      // Note: このような画像ファイル名にハイフンは使用できない。
      case prod:
        return '@drawable/transparent_notification_icon_prod';
      case dev:
        return '@drawable/transparent_notification_icon_dev';
      case local:
        return '@drawable/transparent_notification_icon_local';
    }
  }
}
