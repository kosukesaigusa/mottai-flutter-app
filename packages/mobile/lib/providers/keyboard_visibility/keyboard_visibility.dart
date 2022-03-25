// final isKeyboardVisibleProvider = StreamProvider.autoDispose<bool>(
//   (ref) => ,
// );

// final isKeyboardVisibleProvider = StreamProvider.autoDispose<bool>(
//   (ref) {
//     // final aaa = KeyboardVisibilityController().onChange.listen((visible) => visible);
//     final aaa = KeyboardVisibilityController().onChange;
//     final bbb = KeyboardVisibility
//     return false;
//   },
// );

// final _authProvider = Provider<FirebaseAuth>(
//   (_) => FirebaseAuth.instance,
// );

// final authUserProvider = StreamProvider<User?>(
//   (ref) => ref.watch(_authProvider).userChanges(),
// );

// final userIdProvider = Provider<AsyncValue<String?>>(
//   (ref) => ref.watch(authUserProvider).whenData((user) => user?.uid),
// );

