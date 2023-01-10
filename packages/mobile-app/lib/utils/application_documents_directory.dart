import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// cookie の保存先として使用する ApplicationDocumentDirectory のプロバイダ
final applicationDocumentsDirectoryProvider =
    Provider<Directory>((_) => throw UnimplementedError());
