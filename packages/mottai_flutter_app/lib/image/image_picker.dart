import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// [ImagePickerService] のインスタンスを提供する [Provider]
final imagePickerServiceProvider = Provider.autoDispose<ImagePickerService>(
  (_) => ImagePickerService(),
);
