import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationController = Provider.autoDispose((ref) => NavigationController(ref.read));

class NavigationController {
  NavigationController(this._reader);

  final Reader _reader;
}
