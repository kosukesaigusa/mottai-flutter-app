import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../exception.dart';

final locationServiceProvider = Provider((ref) => LocationService());

/// geolocator で取得した [Position] を返す [FutureProvider].
/// 取得したユーザーの現在の緯度経度が保存される。
final currentPositionProvider = FutureProvider<Position>((ref) {
  return ref.watch(locationServiceProvider).getCurrentPosition();
});

class LocationService {
  /// 現在地を取得するための権限をリクエストする。
  Future<LocationPermission> getLocationPermission() =>
      Geolocator.requestPermission();

  /// 現在地を取得する。
  Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationPermissionException();
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

/// 端末の位置情報の使用許可が得られなかった場合に発生する [AppException].
class LocationPermissionException extends AppException {}
