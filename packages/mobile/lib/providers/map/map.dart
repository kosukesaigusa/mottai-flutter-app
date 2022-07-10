import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../utils/geo.dart';

/// マップのデフォルトの緯度経度。
const _defaultLatLng = LatLng(35.6812, 139.7671);

/// マップのデフォルトのズームレベル。
const double _defaultZoom = 7;

/// マップのデフォルトの検出半径。
const double _defaultRadius = 50;

/// GoogleMap ウィジェットを作成する際に値を更新して使用する。
final googleMapControllerProvider = StateProvider<GoogleMapController?>((_) => null);

/// GeoFlutterFire のインスタンスを提供する Provider。
final geoProvider = Provider.autoDispose((_) => Geoflutterfire());

/// マップの初期中心位置を提供する Provider。ProviderScope.overrides でオーバーライドして使用する。
final initialCenterLatLngProvider = Provider<LatLng>((_) => throw UnimplementedError());

/// マップの中心位置を管理する StateProvider。
final centerLatLngProvider =
    StateProvider.autoDispose((ref) => ref.watch(initialCenterLatLngProvider));

/// マップのズームレベルを管理する StateProvider。
final zoomProvider = StateProvider.autoDispose<double>((_) => _defaultZoom);

/// マップの検出半径を管理する StateProvider。
final radiusProvider = StateProvider.autoDispose<double>((_) => _defaultRadius);

/// マップのカメラ位置を管理する StateProvider。
final cameraPositionProvider = StateProvider(
  (_) => const CameraPosition(target: _defaultLatLng, zoom: _defaultZoom),
);

/// マップで検出されている HostLocation 一覧を管理する StateProvider。
final selectedHostLocationProvider = StateProvider<HostLocation?>((_) => null);

/// マップの検出範囲をリセットするかどうかを管理する StateProvider。
final willResetDetectionRangeProvider = StateProvider((_) => true);

/// マップの検出範囲をリセットするメソッドを提供する Provider。
final resetDetectionRangeProvider = Provider.autoDispose(
  (ref) => () {
    final latLng = ref.watch(cameraPositionProvider).target;
    final zoom = ref.watch(cameraPositionProvider).zoom;
    ref.read(centerLatLngProvider.notifier).update((state) => latLng);
    ref.read(zoomProvider.notifier).update((state) => zoom);
    ref.read(radiusProvider.notifier).update((state) => getRadiusFromZoom(zoom));
  },
);

/// マップを現在位置とデフォルトのズームレベルに戻すメソッドを提供する Provider。
final backToCurrentPositionProvider = Provider.autoDispose(
  (ref) => () async {
    final p = await currentPosition;
    final latLng = p == null ? _defaultLatLng : LatLng(p.latitude, p.longitude);
    await ref.read(googleMapControllerProvider)?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: _defaultZoom),
          ),
        );
  },
);

/// マップの現在の検出範囲内に入っている HostLocation の DocumentSnapshot 一覧を
/// 購読する Stream を提供する Provider。
final hostLocationDocumentSnapshotsStream = StreamProvider.autoDispose((ref) {
  final geo = ref.watch(geoProvider);
  final center = ref.watch(centerLatLngProvider);
  final radius = ref.watch(radiusProvider);
  final collectionReference =
      FirebaseFirestore.instance.collection('hostLocations').withConverter<HostLocation>(
            fromFirestore: (snapshot, _) => HostLocation.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );
  return geo.collectionWithConverter(collectionRef: collectionReference).within(
        center: GeoFirePoint(center.latitude, center.longitude),
        radius: radius,
        field: 'position',
        geopointFrom: (hostLocation) => hostLocation.position.geopoint,
        strictMode: true,
      );
});

/// マップ上に検出された HostLocation 一覧のマーカーを提供する Provider。
final markersProvider = Provider.autoDispose((ref) {
  final documentSnapshots = ref.watch(hostLocationDocumentSnapshotsStream).value;
  final markers = <Marker>{};
  if (documentSnapshots != null) {
    for (final ds in documentSnapshots) {
      final hostLocation = ds.data();
      if (hostLocation == null) {
        continue;
      }
      final marker = ref.watch(getMarkerFromHostLocationProvider)(hostLocation);
      markers.add(marker);
    }
  }
  return markers;
});

/// マップ上に検出された HostLocation 一覧を提供する Provider。
final hostLocationsOnMapProvider = Provider.autoDispose((ref) {
  final documentSnapshots = ref.watch(hostLocationDocumentSnapshotsStream).value;
  final hostLocations = <HostLocation>[];
  if (documentSnapshots != null) {
    for (final ds in documentSnapshots) {
      final hostLocation = ds.data();
      if (hostLocation == null) {
        continue;
      }
      hostLocations.add(hostLocation);
    }
  }
  return hostLocations;
});

/// HostLocation から GoogleMap の Marker インスタンスを作成して返すメソッドを提供する Provider。
final getMarkerFromHostLocationProvider = Provider.autoDispose<Marker Function(HostLocation)>(
  (ref) => (hostLocation) {
    final geopoint = hostLocation.position.geopoint;
    final lat = geopoint.latitude;
    final lng = geopoint.longitude;
    final markerId = _getMarkerIdFromLatLng(LatLng(lat, lng));
    final selected = ref.watch(selectedHostLocationProvider) == hostLocation;
    return Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        selected ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
      ),
      zIndex: selected ? 10 : 0,
      onTap: () async {
        ref.read(willResetDetectionRangeProvider.notifier).update((state) => true);
        ref.read(centerLatLngProvider.notifier).update((state) => LatLng(lat, lng));
        ref.read(selectedHostLocationProvider.notifier).update((state) => hostLocation);
      },
    );
  },
);

/// LatLng から GoogleMap の MarkerId インスタンスを作成して返す。
MarkerId _getMarkerIdFromLatLng(LatLng latLng) =>
    MarkerId(latLng.latitude.toString() + latLng.longitude.toString());

/// PageView ウィジェットのコントローラを提供する Provider。
final pageControllerProvider =
    Provider.autoDispose((_) => PageController(viewportFraction: viewportFraction));

/// PageView ウィジェトの onPageChanged プロパティに指定するメソッドを提供する Provider。
final onPageChangedProvider = Provider.autoDispose<Future<void> Function(int)>(
  (ref) => (index) async {
    ref.read(willResetDetectionRangeProvider.notifier).update((state) => false);
    final hostLocation = ref.read(hostLocationsOnMapProvider).elementAt(index);
    final geopoint = hostLocation.position.geopoint;
    await ref.read(googleMapControllerProvider)?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(geopoint.latitude, geopoint.longitude),
              zoom: ref.read(zoomProvider),
            ),
          ),
        );
    ref.read(selectedHostLocationProvider.notifier).update((state) => hostLocation);
  },
);

/// 位置情報の許可を確認して、許可されている場合は現在の位置を返す。
Future<Position?> get currentPosition async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return null;
  }
  return Geolocator.getCurrentPosition();
}

/// デフォルトのマップ中心位置を決めるためのメソッド。
/// ProviderScope.overrides に指定してアプリの起動時にコールされる。
Future<LatLng> get initialCenterLatLng async {
  final p = await currentPosition;
  return p == null ? _defaultLatLng : LatLng(p.latitude, p.longitude);
}
