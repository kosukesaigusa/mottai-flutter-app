import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MainPage に二度押し防止のローディングスクリーンを重ねるかどうか
final mainPageLoadingProvider = StateProvider<bool>((ref) => false);
