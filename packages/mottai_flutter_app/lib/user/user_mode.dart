import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Worker or Host のどちらとしてアプリを利用しているか。
enum UserMode {
  worker,
  host,
  ;
}

/// Worker or Host のどちらとしてアプリを利用しているかを保持する [StateProvider].
final userModeStateProvider = StateProvider((_) => UserMode.worker);
