import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import '../../package_info.dart';

final inReviewStreamProvider =
    StreamProvider.autoDispose<ReadInReviewConfig?>((ref) {
  final repository =
      ref.watch<InReviewConfigRepository>(inReviewConfigRepositoryProvider);
  return repository.subscribeInReviewConfig();
});

final isInReviewProvider = StateProvider.autoDispose<bool>(
  (ref) {
    final inReviewInfo = ref.watch(inReviewStreamProvider).asData?.value;

    try {
      // 読み込みが終わっていない場合またはエラーの場合
      if (inReviewInfo == null) {
        return false;
      }

      final currentVersion =
          formatVersionNumber(ref.watch(packageInfoProvider).version);

      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          final iosVersion =
              formatVersionNumber(inReviewInfo.iOSInReviewVersion);
          // レビュー中ではない時
          if (!inReviewInfo.enableIOSInReviewMode) {
            return false;
          }
          // レビュー中のバージョンと一致しない時
          if (iosVersion != currentVersion) {
            return false;
          }
          // レビュー中かつバージョンが一致する時
          return true;
        case TargetPlatform.android:
          final androidVersion =
              formatVersionNumber(inReviewInfo.iOSInReviewVersion);
          if (!inReviewInfo.enableAndroidInReviewMode) {
            return false;
          }
          if (androidVersion != currentVersion) {
            return false;
          }
          return true;
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
          throw Exception('このOSは制御していません');
      }
    } on FormatException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  },
);
