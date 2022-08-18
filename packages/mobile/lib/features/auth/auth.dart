import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/loading.dart';

final _authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(_authProvider).userChanges(),
);

final userIdProvider = Provider<AsyncValue<String?>>(
  (ref) => ref.watch(authUserProvider).whenData((user) => user?.uid),
);

final isSignedInProvider = Provider(
  (ref) => ref.watch(userIdProvider).whenData((userId) => userId != null),
);

/// FirebaseAuth からログアウトする。
final signOutProvider = Provider.autoDispose<Future<void> Function()>(
  (ref) => () async {
    try {
      ref.read(overlayLoadingProvider.notifier).update((state) => true);
      await ref.watch(_authProvider).signOut();
    } finally {
      ref.read(overlayLoadingProvider.notifier).update((state) => false);
    }
  },
);
