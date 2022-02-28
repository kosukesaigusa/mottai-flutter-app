import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../theme/theme.dart';
import '../../utils/geo.dart';
import '../../utils/utils.dart';

const double stackedGreyBackgroundHeight = 200;
const double stackedGreyBackgroundBorderRadius = 36;
const double stackedGreyBackgroundPaddingTop = 8;
const double pageViewHeight = 148;
const double pageViewHorizontalMargin = 4;
const double pageViewVerticalMargin = 8;
const double pageViewHorizontalPadding = 8;
const double pageViewVerticalPadding = 16;
const double pageViewBorderRadius = 16;
const double pageViewImageBorderRadius = 16;
const double nearMeCircleSize = 32;
const double nearMeIconSize = 20;

class MapPage extends StatefulHookConsumerWidget {
  const MapPage({Key? key}) : super(key: key);

  static const path = '/map/';
  static const name = 'MapPage';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? _mapController;
  final pageController = PageController(viewportFraction: 0.85);
  late CameraPosition cameraPosition;

  /// デバッグ確認用の半径・ズームレベル
  int debugRadius = initialRadius;
  double debugZoomLevel = initialZoomLevel;

  /// 準備中
  bool ready = false;

  /// 半径の変更を監視する
  final radiusBehaviorSubject = BehaviorSubject<double>.seeded(1);
  final markers = <MarkerId, Marker>{};
  GeoFirePoint center = Geoflutterfire().point(
    latitude: initialLocation.latitude,
    longitude: initialLocation.longitude,
  );

  // late Stream<List<DocumentSnapshot>> stream;
  late Stream<List<DocumentSnapshot<HostLocation>>> typedStream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      geo = Geoflutterfire();
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final currentPosition = await Geolocator.getCurrentPosition();
      center = GeoFirePoint(currentPosition.latitude, currentPosition.longitude);
      cameraPosition = CameraPosition(
        target: LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        ),
        zoom: debugZoomLevel,
      );
      typedStream = radiusBehaviorSubject.switchMap((radius) {
        final collectionReference = HostLocationRepository.hostLocationsRef;
        return geo.collectionWithConverter(collectionRef: collectionReference).within(
              center: center,
              radius: radius,
              field: 'position',
              geopointFrom: (hostLocation) => hostLocation.position.geopoint,
              strictMode: true,
            );
      });
      setState(() {
        ready = true;
      });
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    pageController.dispose();
    radiusBehaviorSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // TODO: ライトモード・ダークモードの切り替えに対応する。
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: ready
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    circles: {
                      Circle(
                        circleId: const CircleId('value'),
                        center: LatLng(center.latitude, center.longitude),
                        radius: debugRadius.toDouble() * 1000,
                        fillColor: Colors.black12,
                        strokeWidth: 0,
                      ),
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(minZoomLevel, maxZoomLevel),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(center.latitude, center.longitude),
                      zoom: debugZoomLevel,
                    ),
                    markers: Set<Marker>.of(markers.values),
                    onCameraIdle: () {
                      final latLng = cameraPosition.target;
                      final zoom = cameraPosition.zoom;
                      final radius = getRadiusFromZoom(zoom);
                      setState(() {
                        markers.clear();
                        debugRadius = radius.toInt();
                        debugZoomLevel = zoom;
                        center = Geoflutterfire().point(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                        );
                        radiusBehaviorSubject.add(radius);
                      });
                    },
                    onCameraMove: (newCameraPosition) {
                      setState(() {
                        cameraPosition = newCameraPosition;
                      });
                    },
                  ),
                  _buildStackedTopIndicator,
                  _buildStackedGreyBackGround,
                  _buildStackedPageViewWidget,
                ],
              )
            : SpinKitCircle(size: 48, color: Theme.of(context).colorScheme.primary),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await _setSeedLocationData();
        //   },
        // ),
      ),
    );
  }

  /// Stack で重ねているデバッグ用のズームレベル、半径のインジケータ
  Widget get _buildStackedTopIndicator => Positioned(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 48, left: 16, right: 16),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('デバッグウィンドウ', style: whiteBold12),
                const Gap(8),
                Text(
                  'Center: (lat, lng) = ('
                  '${(center.geoPoint.latitude * 1000).round() / 1000}, '
                  '${(center.geoPoint.longitude * 1000).round() / 1000})',
                  style: white12,
                ),
                Text(
                  'Zoom level: ${(debugZoomLevel * 100).round() / 100}',
                  style: white12,
                ),
                Text(
                  'Radius: ${addComma(debugRadius)} km',
                  style: white12,
                ),
                const Text(
                  '検出範囲は、画面中央を中心とする薄灰色の円の内側です。',
                  style: white12,
                ),
                const Gap(8),
                Slider(
                  min: minZoomLevel,
                  max: maxZoomLevel,
                  divisions: (maxZoomLevel - minZoomLevel).toInt(),
                  value: debugZoomLevel,
                  onChanged: (value) {
                    setState(() {
                      final latLng = cameraPosition.target;
                      final zoom = value;
                      final radius = getRadiusFromZoom(zoom);
                      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: latLng,
                          zoom: zoom,
                        ),
                      ));
                      setState(() {
                        markers.clear();
                        debugRadius = radius.toInt();
                        debugZoomLevel = zoom;
                        center = Geoflutterfire().point(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                        );
                        radiusBehaviorSubject.add(radius);
                      });
                    });
                  },
                ),
                const Gap(8),
              ],
            ),
          ),
        ),
      );

  /// Stack で重ねている画面下部のグレー背景部分
  Widget get _buildStackedGreyBackGround => Positioned(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: stackedGreyBackgroundHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(stackedGreyBackgroundBorderRadius),
                topRight: Radius.circular(stackedGreyBackgroundBorderRadius),
              ),
            ),
          ),
        ),
      );

  /// Stack で重ねている PageView と near_me アイコン部分
  Widget get _buildStackedPageViewWidget => Positioned(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 32),
                width: nearMeCircleSize,
                height: nearMeCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: GestureDetector(
                  onTap: _showHome,
                  child: const Icon(
                    Icons.near_me,
                    size: nearMeIconSize,
                    color: Colors.white,
                  ),
                ),
              ),
              const Gap(pageViewVerticalMargin),
              SizedBox(
                height: stackedGreyBackgroundHeight -
                    pageViewVerticalMargin * 2 -
                    nearMeCircleSize -
                    stackedGreyBackgroundPaddingTop,
                child: PageView(
                  controller: pageController,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    for (final index in List<int>.generate(10, (i) => i)) _buildPageItem(index),
                  ],
                ),
              ),
              const Gap(pageViewVerticalMargin),
            ],
          ),
        ),
      );

  /// PageView のアイテム
  Widget _buildPageItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: pageViewHorizontalMargin),
      padding: const EdgeInsets.symmetric(
        horizontal: pageViewHorizontalPadding,
        vertical: pageViewVerticalPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(pageViewBorderRadius)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(pageViewImageBorderRadius),
                child: Image.network(
                  'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
                ),
              ),
            ),
          ),
          const Gap(8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${index + 1} 番目のホスト', style: bold14),
                const Gap(4),
                Text(
                  '神奈川県小田原市でみかんを育てています！'
                  'みかん収穫のお手伝いをしてくださる方募集中です🍊'
                  'ぜひお気軽にマッチングリクエストお願いします！',
                  style: grey12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '神奈川県小田原市247番3',
                      style: grey12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Map の初回描画時に実行する
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      typedStream.listen(_updateTypedMarkers);
    });
  }

  /// locations コレクションの位置情報リストを取得し、そのそれぞれに対して
  /// _addMarker() メソッドをコールして状態変数に格納する
  void _updateTypedMarkers(List<DocumentSnapshot<HostLocation>> hostLocations) {
    for (final location in hostLocations) {
      final data = location.data();
      if (data == null) {
        continue;
      }
      final geopoint = data.position.geopoint;
      _addMarker(geopoint.latitude, geopoint.longitude);
    }
  }

  /// 受け取った緯度・経度の Marker オブジェクトインスタンスを生成して
  /// その位置情報を状態変数の Map に格納する。
  /// 緯度・経度の組をもとにした ID をキーにMap 型で取り扱っているので
  /// Marker が重複することはない。
  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  Future<void> _showHome() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final currentPosition = await Geolocator.getCurrentPosition();
    await _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: initialZoomLevel,
      ),
    ));
  }

  void changed(double value) {
    // setState(markers.clear);
    radiusBehaviorSubject.add(value);
  }

  Future<void> _setSeedLocationData() async {
    final batch = db.batch();
    for (var i = 0; i < 500; i++) {
      final hostLocationId = uuid;
      final random = Random();
      // 日本
      final minLatitude = doubleFromDegree(degree: 33, minute: 13, second: 04);
      final maxLatitude = doubleFromDegree(degree: 43, minute: 23, second: 06);
      final minLongitude = doubleFromDegree(degree: 129, minute: 33, second: 09);
      final maxLongitude = doubleFromDegree(degree: 145, minute: 48, second: 58);
      // 小田原市
      // final minLatitude = doubleFromDegree(degree: 35, minute: 10, second: 41);
      // final maxLatitude = doubleFromDegree(degree: 35, minute: 19, second: 48);
      // final minLongitude = doubleFromDegree(degree: 139, minute: 03, second: 37);
      // final maxLongitude = doubleFromDegree(degree: 139, minute: 14, second: 18);
      final f1 = random.nextDouble();
      final f2 = random.nextDouble();
      final latitude = minLatitude + (maxLatitude - minLatitude) * f1;
      final longitude = minLongitude + (maxLongitude - minLongitude) * f2;
      final geoFirePoint = geo.point(latitude: latitude, longitude: longitude);
      final hostLocation = HostLocation(
        hostLocationId: uuid,
        title: 'ホスト：${uuid.substring(0, 15)}',
        hostId: uuid,
        address: '東京都あいうえお区かきくけこ1-2-3',
        description: '神奈川県小田原市でみかんを育てています！'
            'みかん収穫のお手伝いをしてくださる方募集中です🍊'
            'ぜひお気軽にマッチングリクエストお願いします！',
        imageURL: 'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
        position: FirestorePosition(
          geohash: geoFirePoint.data['geohash'] as String,
          geopoint: geoFirePoint.data['geopoint'] as GeoPoint,
        ),
      );
      // await HostLocationRepository.hostLocationRef(
      //   hostLocationId: hostLocationId,
      // ).set(hostLocation);
      batch.set(
        HostLocationRepository.hostLocationRef(hostLocationId: hostLocationId),
        hostLocation,
      );
      print('${i + 1} 番目書き込み完了');
      // await db.collection('locations').doc(hostLocationId).set(<String, dynamic>{
      //   'position': <String, dynamic>{
      //     'geohash': geohash,
      //     'geopoint': geopoint,
      //   }
      // });
    }
    await batch.commit();
    print('バッチコミットしました');
    showFloatingSnackBar(context, '完了しました');
  }
}
