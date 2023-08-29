import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';
import '../package_info.dart';

final forceUpdateStreamProvider =
    StreamProvider.autoDispose<ReadForceUpdateConfig?>((ref) {
  final repository = ref.watch(forceUpdateConfigRepositoryProvider);
  return repository.subscribeForceUpdateConfig();
});

final isForceUpdateRequiredProvider = StateProvider.autoDispose<bool>(
  (ref) {
    final forceUpdateInfo = ref.watch(forceUpdateStreamProvider).asData?.value;

    try {
      // 読み込みが終わっていない場合またはエラーの場合
      if (forceUpdateInfo == null) {
        return false;
      }
      final currentVersion = ref.watch(packageInfoProvider).version;
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          if (!forceUpdateInfo.iOSForceUpdate) {
            return false;
          }
          return isCurrentVersionLessThanMinRequiredVersion(
            currentVersion,
            forceUpdateInfo.iOSMinRequiredVersion,
          );
        case TargetPlatform.android:
          if (!forceUpdateInfo.androidForceUpdate) {
            return false;
          }
          return isCurrentVersionLessThanMinRequiredVersion(
            currentVersion,
            forceUpdateInfo.androidMinRequiredVersion,
          );
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
          throw UnimplementedError();
      }
    } on FormatException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  },
);
