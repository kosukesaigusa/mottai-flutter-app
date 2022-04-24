import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アプリ全体に二度押し防止のローディングスクリーンを重ねるかどうか
final overlayLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
