import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../geolocator.dart';

final currentLocationControllerProvider = Provider.autoDispose<CurrentLocationController>(
  (ref) => CurrentLocationController(
    locationService: ref.watch(locationServiceProvider),
    appScaffoldMessengerController: ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class CurrentLocationController {
  const CurrentLocationController({
    required LocationService locationService,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _locationService = locationService,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final LocationService _locationService;
  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// 現在地取得のための権限を取得する
  Future<void> getCurrentPosition() async {
    final locationPermission = await _locationService.getLocationPermission();

    if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
      _appScaffoldMessengerController.showSnackBar('位置情報を取得する権限を得られませんでした');
    } else {
      await _locationService.getCurrentPosition();
    }
  }
}
