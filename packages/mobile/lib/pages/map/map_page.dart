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

  /// 検出範囲を変更するかどうか
  bool resetDetection = true;

  /// 半径の変更を監視する
  final radiusBehaviorSubject = BehaviorSubject<double>.seeded(1);

  /// マップ上に表示するマーカー
  final markers = <MarkerId, Marker>{};

  /// マップ上に表示するマーカーに対応する HostLocation
  final hostLocationsOnMap = <HostLocation>[];

  /// 最後にタップしたマーカーに対応する HostLocation
  HostLocation? lastTappedHostLocation;

  /// マップの中心
  GeoFirePoint center = Geoflutterfire().point(
    latitude: initialLocation.latitude,
    longitude: initialLocation.longitude,
  );

  late Stream<List<DocumentSnapshot<HostLocation>>> hostLocationsStream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      geo = Geoflutterfire();
      final p = await currentPosition;
      center = GeoFirePoint(
        p?.latitude ?? initialLocation.latitude,
        p?.longitude ?? initialLocation.longitude,
      );
      cameraPosition = CameraPosition(
        target: LatLng(center.latitude, center.longitude),
        zoom: debugZoomLevel,
      );
      hostLocationsStream = radiusBehaviorSubject.switchMap((radius) {
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
                      // マップのドラッグ操作による移動およびズームの変更のときのみ。
                      // 検出範囲をリセットする。
                      if (resetDetection) {
                        final zoom = cameraPosition.zoom;
                        _updateDetectionRange(
                          latLng: cameraPosition.target,
                          r: getRadiusFromZoom(zoom),
                          zoom: zoom,
                        );
                      } else {
                        // PageView のスワイプによるカメラ移動ではここが動作する。
                        // 次のマップのドラッグ操作・ズーム変更に備えて true に更新する。
                        setState(() {
                          resetDetection = true;
                        });
                      }
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
                const Text(
                  '検出範囲は、画面中央を中心とする薄灰色の円の内側です。',
                  style: white12,
                ),
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
                Text(
                  '検出件数：${addComma(markers.length)} 件',
                  style: white12,
                ),
                // Text(
                //   '選択中: ${selectedHostLocation?.hostLocationId ?? ''}',
                //   style: white12,
                // ),
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
                      _updateCameraPosition(latLng: latLng, zoom: zoom);
                      _updateDetectionRange(latLng: latLng, r: getRadiusFromZoom(zoom), zoom: zoom);
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
                  onTap: _backToOriginalPosition,
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
                  onPageChanged: (index) async {
                    // PageView のスワイプによるカメラ移動では
                    // 検出範囲をリセットしない
                    setState(() {
                      resetDetection = false;
                    });
                    // ページビューを移動した先の HostLocation インスタンス
                    final hostLocation = hostLocationsOnMap.elementAt(index);
                    final geopoint = hostLocation.position.geopoint;
                    final zoomLevel = await _mapController!.getZoomLevel();
                    await _updateCameraPosition(
                      latLng: LatLng(geopoint.latitude, geopoint.longitude),
                      zoom: zoomLevel,
                    );
                  },
                  children: [
                    for (final hostLocation in hostLocationsOnMap) _buildPageItem(hostLocation),
                  ],
                ),
              ),
              const Gap(pageViewVerticalMargin),
            ],
          ),
        ),
      );

  /// PageView のアイテム
  Widget _buildPageItem(HostLocation hostLocation) {
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
                Text(
                  hostLocation.hostLocationId,
                  style: bold14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
      hostLocationsStream.listen(_updateMarkers);
    });
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
        setState(() {
          resetDetection = true;
        });
        await _updateCameraPosition(latLng: LatLng(lat, lng), zoom: debugZoomLevel);
        // 移動・状態更新後の index を取得する
        final index = hostLocationsOnMap.indexWhere((l) => hostLocation == l);
        setState(() {
          lastTappedHostLocation = hostLocation;
        });
        pageController.jumpToPage(index);
      },
    );
    setState(() {
      markers[markerId] = marker;
      hostLocationsOnMap.add(hostLocation);
    });
  }

  /// カメラポジションとズームを移動する
  Future<void> _updateCameraPosition({
    required LatLng latLng,
    required double zoom,
  }) async {
    await _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: zoom),
    ));
  }

  /// Zoom と CameraPosition を元に戻す
  Future<void> _backToOriginalPosition() async {
    final p = await currentPosition;
    await _updateCameraPosition(
      latLng: LatLng(
        p?.latitude ?? initialLocation.latitude,
        p?.longitude ?? initialLocation.longitude,
      ),
      zoom: initialZoomLevel,
    );
  }

  /// 表示中のピンをリセットして検出範囲を更新する
  void _updateDetectionRange({
    required LatLng latLng,
    required double r,
    required double zoom,
  }) {
    setState(() {
      markers.clear();
      hostLocationsOnMap.clear();
      debugRadius = r.toInt();
      debugZoomLevel = zoom;
      center = Geoflutterfire().point(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );
      radiusBehaviorSubject.add(r);
    });
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

  /// シードデータを作成する
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
  }
}
