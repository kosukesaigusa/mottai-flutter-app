import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

/// 指定した [Host] ドキュメントを購読する [StreamProvider].
final hostStreamProvider = StreamProvider.family.autoDispose<ReadHost?, String>(
  (ref, hostId) =>
      ref.watch(hostRepositoryProvider).subscribeHost(hostId: hostId),
);

/// 指定した [Host] の画像 URL を返す [Provider].
/// 画像が存在しない場合や読み込み中・エラーの場合でもから文字を返す。
final hostImageUrlProvider =
    Provider.family.autoDispose<String, String>((ref, hostId) {
  final host = ref.watch(hostStreamProvider(hostId)).valueOrNull;
  return host?.imageUrl ?? '';
});

/// 指定した [Host] の名前を返す [Provider].
/// 読み込み中・エラーの場合は'農家さん'を返す。
final hostDisplayNameProvider =
    Provider.family.autoDispose<String, String>((ref, hostId) {
  final host = ref.watch(hostStreamProvider(hostId)).valueOrNull;
  return host?.displayName ?? '農家さん';
});
