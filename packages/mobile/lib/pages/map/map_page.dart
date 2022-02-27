import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/theme/theme.dart';
import 'package:mottai_flutter_app/utils/utils.dart';
import 'package:mottai_flutter_app_models/models.dart';
import 'package:rxdart/rxdart.dart';

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

  final radiusBehaviorSubject = BehaviorSubject<double>.seeded(1);
  final markers = <MarkerId, Marker>{};
  // final kagurazakaLatLng = const LatLng(31.921651553011934, 138.20455801498437);
  final kagurazakaLatLng = const LatLng(35.7015, 139.7403);
  GeoFirePoint center = Geoflutterfire().point(
    latitude: 35.7015,
    longitude: 139.7403,
  );

  // late Stream<List<DocumentSnapshot>> stream;
  late Stream<List<DocumentSnapshot<HostLocation>>> typedStream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    cameraPosition = CameraPosition(target: kagurazakaLatLng, zoom: 15);
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
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await _setSeedLocationData();
      //   },
      // ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: kagurazakaLatLng,
              zoom: 15,
            ),
            markers: Set<Marker>.of(markers.values),
            onCameraIdle: () {
              final latLng = cameraPosition.target;
              // min: 2, max: 21？
              final zoom = cameraPosition.zoom;
              final radius = _radiusFromZoom(zoom);
              print('----------------------------------------');
              print('(zoom, radius): ($zoom, $radius km)');
              print('----------------------------------------');
              setState(() {
                markers.clear(); // 悪くない、最適化必要
                center = Geoflutterfire().point(
                  latitude: latLng.latitude,
                  longitude: latLng.longitude,
                );
                radiusBehaviorSubject.add(radius);
              });
              typedStream.listen(_updateTypedMarkers);
            },
            onCameraMove: (newCameraPosition) {
              setState(() {
                cameraPosition = newCameraPosition;
              });
            },
          ),
          _buildStackedGreyBackGround,
          _buildStackedPageViewWidget,
        ],
      ),
    );
  }

  /// GoogleMap の CameraPosition.zoom の値から半径を決定する
  double _radiusFromZoom(double zoom) {
    if (zoom < 5) {
      return 500;
    }
    if (zoom < 10) {
      return 300;
    }
    if (zoom < 15) {
      return 100;
    }
    return 10;
  }

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

  void _showHome() {
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: kagurazakaLatLng,
        zoom: 15,
      ),
    ));
  }

  void changed(double value) {
    // setState(markers.clear);
    radiusBehaviorSubject.add(value);
  }

  Future<void> _setSeedLocationData() async {
    for (var i = 0; i < 1000; i++) {
      final hostLocationId = uuid;
      final random = Random();
      const minLatitude = 20.2531;
      const maxLatitude = 35.5354;
      const minLongitude = 136.0411;
      const maxLongitude = 139.0106;
      final f1 = random.nextDouble();
      final f2 = random.nextDouble();
      final latitude = minLatitude + (maxLatitude - minLatitude) * f1;
      final longitude = minLongitude + (maxLongitude - minLongitude) * f2;
      final geoFirePoint = geo.point(latitude: latitude, longitude: longitude);
      final hostLocation = HostLocation(
        hostLocationId: hostLocationId,
        title: '${i + 1} 番目のホスト',
        hostId: uuid,
        address: '東京都あいうえお区かきくけこ1-2-3',
        description: '神奈川県小田原市でみかんを育てています！'
            'みかん収穫のお手伝いをしてくださる方募集中です🍊'
            'ぜひお気軽にマッチングリクエストお願いします！',
        imageURL: 'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
        position: Position(
          geohash: geoFirePoint.data['hash'] as String,
          geopoint: geoFirePoint.data['point'] as GeoPoint,
        ),
      );
      await HostLocationRepository.hostLocationRef(
        hostLocationId: hostLocationId,
      ).set(hostLocation);
      // await db.collection('locations').doc(hostLocationId).set(<String, dynamic>{
      //   'position': <String, dynamic>{
      //     'geohash': geohash,
      //     'geopoint': geopoint,
      //   }
      // });
    }
  }
}
