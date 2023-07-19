import 'dart:io';

import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../package_info.dart';

final forceUpdateFutureProvider =
    StreamProvider.autoDispose<ReadForceUpdateConfig?>((ref) {
  final repository = ref.watch(forceUpdateConfigRepositoryProvider);
  return repository.subscribeForceUpdateConfig();
});

final isForceUpdateProvider = Provider.autoDispose<bool>(
  (ref) {
    final forceUpdateInfo = ref.watch(forceUpdateFutureProvider).asData?.value;

    // 読み込みが終わっていない場合またはエラーの場合
    if (forceUpdateInfo == null) {
      return false;
    } else {
      final packageInfo = ref.watch(packageInfoProvider);
      final isIOS = Platform.isIOS;
      final version = _formatVersionNumber(packageInfo.version);
      // iOSの時
      if (isIOS) {
        // 強制アップデート
        if (forceUpdateInfo.iOSForceUpdate) {
          return true;
        } else {
          // バージョンが範囲内になければアップデート
          final iOSLatestVersion =
              _formatVersionNumber(forceUpdateInfo.iOSLatestVersion);
          final iOSMinRequiredVersion =
              _formatVersionNumber(forceUpdateInfo.iOSMinRequiredVersion);
          if (iOSMinRequiredVersion <= version && version <= iOSLatestVersion) {
            return false;
          } else {
            return true;
          }
        }
        // Androidの時
      } else {
        // 強制アップデート
        if (forceUpdateInfo.androidForceUpdate) {
          return true;
        } else {
          // バージョンが範囲内になければアップデート
          final androidLatestVersion =
              _formatVersionNumber(forceUpdateInfo.androidLatestVersion);
          final androidMinRequiredVersion =
              _formatVersionNumber(forceUpdateInfo.androidMinRequiredVersion);
          if (androidMinRequiredVersion <= version &&
              version <= androidLatestVersion) {
            return false;
          } else {
            return true;
          }
        }
      }
    }
  },
);

int _formatVersionNumber(String version) {
  final sb = StringBuffer();

  final versionNumbers = version.split('.');

  sb.writeAll(versionNumbers);

  return int.parse(sb.toString());
}
