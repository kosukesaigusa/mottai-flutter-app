import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 選択された画像ファイル。
final pickedImageFileStateProvider =
    StateProvider.autoDispose<File?>((_) => null);

/// アップロードした画像ファイルのパスを管理。
final uploadedImagePathStateProvider =
    StateProvider.autoDispose<String>((_) => '');

/// アップロードした画像ファイルのURLを管理。
final uploadedImageUrlStateProvider =
    StateProvider.autoDispose<String>((_) => '');

/// 取得した画像URLのリストを管理。
final imageUrlsStateProvider =
    StateProvider.autoDispose<List<String>>((ref) => <String>[]);
