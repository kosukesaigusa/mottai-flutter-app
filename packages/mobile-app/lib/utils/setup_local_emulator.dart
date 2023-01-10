import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'logger.dart';

/// Firebase Emulator Suite に接続するための設定を行う。
Future<void> setUpLocalEmulator({
  String localhost = 'localhost',
  int firestorePortNumber = 8080,
  int functionsPortNumber = 5001,
  int authPortNumber = 9099,
  int storagePortNumber = 9199,
  String region = 'asia-northeast1',
  String bucket = 'default-bucket',
  bool firestoreSSLEnabled = false,
  bool firestorePersistenceEnabled = true,
}) async {
  logger.info('Running with Firebase Local Emulator Suite');
  FirebaseFirestore.instance.settings = Settings(
    host: Platform.isAndroid ? '10.0.2.2:$firestorePortNumber' : '$localhost:$firestorePortNumber',
    sslEnabled: firestoreSSLEnabled,
    persistenceEnabled: firestorePersistenceEnabled,
  );
  FirebaseFirestore.instance.useFirestoreEmulator(localhost, firestorePortNumber);
  FirebaseFunctions.instanceFor(region: region)
      .useFunctionsEmulator(localhost, functionsPortNumber);
  FirebaseStorage.instanceFor(bucket: bucket);
  await Future.wait<void>(
    [
      FirebaseAuth.instance.useAuthEmulator(localhost, authPortNumber),
      FirebaseStorage.instance.useStorageEmulator(localhost, storagePortNumber),
    ],
  );
}
