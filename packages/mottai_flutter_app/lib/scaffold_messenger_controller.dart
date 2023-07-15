import 'package:dart_flutter_common/dart_flutter_common.dart' as common;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scaffoldMessengerKeyProvider =
    Provider((_) => GlobalKey<ScaffoldMessengerState>());

final appScaffoldMessengerControllerProvider = Provider.autoDispose(
  (ref) => AppScaffoldMessengerController(
    scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
  ),
);

/// ツリー上部の [ScaffoldMessenger] 上でスナックバーやダイアログの表示を操作する。
/// dart_flutter_common の [common.ScaffoldMessengerController] を継承して
/// 当該パッケージ用に機能を追加している。
class AppScaffoldMessengerController
    extends common.ScaffoldMessengerController {
  AppScaffoldMessengerController({required super.scaffoldMessengerKey});

  /// [FirebaseException] 起点で [SnackBar] を表示する。
  ScaffoldFeatureController<SnackBar,
      SnackBarClosedReason> showSnackBarByFirebaseException(
    FirebaseException e,
  ) =>
      showSnackBar('[${e.code}]: ${e.message ?? 'FirebaseException が発生しました。'}');
}
