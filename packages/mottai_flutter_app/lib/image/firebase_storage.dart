import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// [FirebaseStorageService] のインスタンスを提供する [Provider]
final firebaseStorageServiceProvider =
    Provider.autoDispose<FirebaseStorageService>(
  (_) => FirebaseStorageService(),
);
