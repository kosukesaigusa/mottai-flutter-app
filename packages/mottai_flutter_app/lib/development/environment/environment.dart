import 'package:hooks_riverpod/hooks_riverpod.dart';

final flavorNameProvider = StateProvider.autoDispose<String>((ref) {
  return const String.fromEnvironment('flavor');
});

final appNameProvider = StateProvider.autoDispose<String>((ref) {
  return const String.fromEnvironment('appName');
});

final appIdSuffixProvider = StateProvider.autoDispose<String>((ref) {
  return const String.fromEnvironment('appIdSuffix');
});

final lineChannelIdProvider = StateProvider.autoDispose<String>((ref) {
  return const String.fromEnvironment('LINE_CHANNEL_ID');
});
