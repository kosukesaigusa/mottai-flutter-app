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

  final radiusBehaviorSubject = BehaviorSubject<double>.seeded(1);
  final markers = <MarkerId, Marker>{};
  // final kagurazakaLatLng = const LatLng(31.921651553011934, 138.20455801498437);
  final kagurazakaLatLng = const LatLng(35.7015, 139.7403);
  GeoFirePoint center = Geoflutterfire().point(
    latitude: 35.7015,
    longitude: 139.7403,
  );

  late Stream<List<DocumentSnapshot>> stream;
  late Stream<List<DocumentSnapshot<HostLocation>>> typedStream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    // stream = radius.switchMap((radius) {
    //   final collectionReference = db.collection('locations');
    //   return geo
    //       .collection(collectionRef: collectionReference)
    //       .within(center: center, radius: radius, field: 'position', strictMode: true);
    // });
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
            onCameraMove: (cameraPosition) {
              final latLng = cameraPosition.target;
              // min: 2, max: 21？
              final zoom = cameraPosition.zoom;
              final radius = _radiusFromZoom(zoom);
              print('----------------------------------------');
              print('(zoom, radius): ($zoom, $radius km)');
              print('----------------------------------------');
              setState(() {
                center = Geoflutterfire().point(
                  latitude: latLng.latitude,
                  longitude: latLng.longitude,
                );
                radiusBehaviorSubject.add(radius);
              });
              typedStream.listen(_updateTypedMarkers);
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
    if (zoom < 2) {
      return 500;
    }
    if (zoom < 5) {
      return 100;
    }
    if (zoom < 10) {
      return 5;
    }
    if (zoom < 15) {
      return 1;
    }
    return 0.5;
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
      // stream.listen(_updateMarkers);
      typedStream.listen(_updateTypedMarkers);
    });
  }

  /// locations コレクションの位置情報リストを取得し、そのそれぞれに対して
  /// _addMarker() メソッドをコールして状態変数に格納する
  void _updateMarkers(List<DocumentSnapshot> documentList) {
    for (final document in documentList) {
      final data = document.data() as Map<String, dynamic>?;
      if (data == null) {
        continue;
      }
      final point = data['position']['geopoint'] as GeoPoint;
      _addMarker(point.latitude, point.longitude);
    }
  }

  void _updateTypedMarkers(List<DocumentSnapshot<HostLocation>> hostLocations) {
    for (final location in hostLocations) {
      final data = location.data();
      if (data == null) {
        continue;
      }
      final point = data.position.geopoint;
      _addMarker(point.latitude, point.longitude);
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? _mapController;
  TextEditingController? _latitudeController, _longitudeController;

  // firestore init
  final radius = BehaviorSubject<double>.seeded(1);
  final _firestore = FirebaseFirestore.instance;
  final markers = <MarkerId, Marker>{};

  late Stream<List<DocumentSnapshot>> stream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    geo = Geoflutterfire();
    final center = geo.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      final collectionReference = _firestore.collection('locations');

      return geo
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: rad, field: 'position', strictMode: true);

      /*
      ****Example to specify nested object****

      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');

      */
    });
  }

  @override
  void dispose() {
    _latitudeController?.dispose();
    _longitudeController?.dispose();
    radius.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GeoFlutterFire'),
          actions: <Widget>[
            IconButton(
              onPressed: _mapController == null ? null : _showHome,
              icon: const Icon(Icons.home),
            )
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: mediaQuery.size.width - 30,
                    height: mediaQuery.size.height * (1 / 3),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(12.960632, 77.641603),
                        zoom: 15,
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Slider(
                  min: 1,
                  max: 200,
                  divisions: 4,
                  value: _value,
                  label: _label,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.2),
                  onChanged: changed,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'lat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'lng',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
                      final lat = double.parse(_latitudeController?.text ?? '0.0');
                      final lng = double.parse(_longitudeController?.text ?? '0.0');
                      _addPoint(lat, lng);
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              MaterialButton(
                color: Colors.amber,
                child: const Text(
                  'Add nested ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final lat = double.parse(_latitudeController?.text ?? '0.0');
                  final lng = double.parse(_longitudeController?.text ?? '0.0');
                  _addNestedPoint(lat, lng);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
//      _showHome();
      //start listening after map is created
      stream.listen(_updateMarkers);
    });
  }

  void _showHome() {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(12.960632, 77.641603),
        zoom: 15,
      ),
    ));
  }

  void _addPoint(double lat, double lng) {
    final geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore
        .collection('locations')
        .add(<String, dynamic>{'name': 'random name', 'position': geoFirePoint.data}).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  //example to add geoFirePoint inside nested object
  void _addNestedPoint(double lat, double lng) {
    final geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('nestedLocations').add(<String, dynamic>{
      'name': 'random name',
      'address': {
        'location': <String, dynamic>{'position': geoFirePoint.data}
      }
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    for (final document in documentList) {
      final data = document.data()! as Map<String, dynamic>;
      final point = data['position']['geopoint'] as GeoPoint;
      _addMarker(point.latitude, point.longitude);
    }
  }

  double _value = 20;
  String _label = '';

  void changed(double value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }
}
