import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/geo.dart';
import 'map_page_state.dart';

final mapPageController = StateNotifierProvider<MapPageController, MapPageState>(
  (ref) => MapPageController(),
);

class MapPageController extends StateNotifier<MapPageState> {
  MapPageController() : super(const MapPageState()) {
    initialize();
  }

  final pageController = PageController(viewportFraction: viewportFraction);
  late GoogleMapController googleMapController;
  late CameraPosition cameraPosition;

  /// 検出半径の変更を監視する
  final radiusBehaviorSubject = BehaviorSubject<double>.seeded(1);

  /// 検出された HostLocation の DocumentSnapshot を監視する
  late Stream<List<DocumentSnapshot<HostLocation>>> hostLocationsStream;

  /// ウィジェットの initState でコールする
  Future<void> initialize() async {
    final geo = Geoflutterfire();
    final p = await currentPosition;
    state = state.copyWith(
      center: p != null ? LatLng(p.latitude, p.longitude) : state.center,
    );
    cameraPosition = CameraPosition(
      target: LatLng(state.center.latitude, state.center.longitude),
      zoom: state.debugZoomLevel,
    );
    hostLocationsStream = radiusBehaviorSubject.switchMap((radius) {
      final collectionReference = HostLocationRepository.hostLocationsRef;
      return geo.collectionWithConverter(collectionRef: collectionReference).within(
            center: GeoFirePoint(state.center.latitude, state.center.longitude),
            radius: radius,
            field: 'position',
            geopointFrom: (hostLocation) => hostLocation.position.geopoint,
            strictMode: true,
          );
    });
    state = state.copyWith(ready: true);
  }

  @override
  void dispose() {
    googleMapController.dispose();
    pageController.dispose();
    radiusBehaviorSubject.close();
    super.dispose();
  }

  /// Map の初回描画時に実行する
  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    hostLocationsStream.listen(_updateMarkers);
  }

  /// locations コレクションの位置情報リストを取得し、そのそれぞれに対して
  /// _addMarker() メソッドをコールして状態変数に格納する
  void _updateMarkers(List<DocumentSnapshot<HostLocation>> documentSnapshots) {
    for (final ds in documentSnapshots) {
      final hostLocation = ds.data();
      if (hostLocation == null) {
        continue;
      }
      _addMarker(hostLocation);
    }
  }

  /// 受け取った緯度・経度の Marker オブジェクトインスタンスを生成して
  /// その位置情報を状態変数の Map に格納する。
  /// 緯度・経度の組をもとにした ID をキーにMap 型で取り扱っているので
  /// Marker が重複することはない。
  void _addMarker(HostLocation hostLocation) {
    final geopoint = hostLocation.position.geopoint;
    final lat = geopoint.latitude;
    final lng = geopoint.longitude;
    final markerId = MarkerId(lat.toString() + lng.toString());
    final marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () async {
        enableResetDetection();
        await updateCameraPosition(latLng: LatLng(lat, lng), zoom: state.debugZoomLevel);
        // 移動・状態更新後の index を取得する
        final index = state.hostLocationsOnMap.indexWhere((l) => hostLocation == l);
        pageController.jumpToPage(index);
      },
    );
    final markers = state.markers;
    markers[markerId] = marker;
    state = state.copyWith(
      markers: markers,
      hostLocationsOnMap: [...state.hostLocationsOnMap, hostLocation],
    );
  }

  /// カメラポジションとズームを移動する
  Future<void> updateCameraPosition({
    required LatLng latLng,
    required double zoom,
  }) async {
    await googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: zoom),
    ));
  }

  /// Zoom と CameraPosition を元に戻す
  Future<void> backToOriginalPosition() async {
    final p = await currentPosition;
    await updateCameraPosition(
      latLng: LatLng(
        p?.latitude ?? initialLocation.latitude,
        p?.longitude ?? initialLocation.longitude,
      ),
      zoom: initialZoomLevel,
    );
  }

  /// 表示中のピンをリセットして検出範囲を更新する
  void updateDetectionRange({
    required LatLng latLng,
    required double radius,
    required double zoomLevel,
  }) {
    state = state.copyWith(
      markers: {},
      hostLocationsOnMap: [],
      debugRadius: radius.toInt(),
      debugZoomLevel: zoomLevel,
      center: latLng,
    );
    radiusBehaviorSubject.add(radius);
  }

  /// 位置情報の許可を確認して、許可されている場合は現在の位置を返す
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

  ///
  void onCameraMove(CameraPosition newCameraPosition) {
    cameraPosition = newCameraPosition;
  }

  ///
  void enableResetDetection() {
    state = state.copyWith(resetDetection: true);
  }

  ///
  void disableResetDetection() {
    state = state.copyWith(resetDetection: false);
  }
}
