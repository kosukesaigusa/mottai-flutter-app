import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../../widgets/dialog/permission_handler_dialog.dart';
import '../geolocator.dart';

final currentLocationControllerProvider =
    Provider.autoDispose<CurrentLocationController>(
  (ref) => CurrentLocationController(
    locationService: ref.watch(locationServiceProvider),
    appScaffoldMessengerController: ref.watch(
      appScaffoldMessengerControllerProvider,
    ),
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

  /// 端末の位置情報を使用するための権限を確認しつつ、現在地を取得する。
  Future<Position?> getCurrentPosition() async {
    final locationPermission = await _locationService.getLocationPermission();

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      await _appScaffoldMessengerController.showDialogByBuilder<bool>(
        builder: (context) => const AccessDeniedDialog.location(),
      );
      return null;
    }
    try {
      return _locationService.getCurrentPosition();
    } on LocationPermissionException {
      await _appScaffoldMessengerController.showDialogByBuilder<bool>(
        builder: (context) => const AccessDeniedDialog.location(),
      );
    }
    return null;
  }
}
