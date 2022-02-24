import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/map/map_page_state.dart';
import 'package:state_notifier/state_notifier.dart';

final mapPageController = StateNotifierProvider<MapPageController, MapPageState>(
  (ref) => MapPageController(),
);

class MapPageController extends StateNotifier<MapPageState> with LocatorMixin {
  MapPageController() : super(const MapPageState());
}
