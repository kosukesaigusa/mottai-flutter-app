// 現在地を取得するための権限を取得
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationServiceProvider = Provider((ref) => LocationService());

/// geolocator で取得した [Position] を返す [FutureProvider].
/// 取得したユーザーの現在の緯度経度が保存される
final currentPositionProvider = FutureProvider<Position>((ref) {
  return ref.watch(locationServiceProvider).getCurrentPosition();
});

class LocationService {
  // 現在地を取得する権限を取得
  Future<LocationPermission> getLocationPermission() async {
    return Geolocator.requestPermission();
  }

  // 現在地を取得
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('位置情報サービスが使えない状態です');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
