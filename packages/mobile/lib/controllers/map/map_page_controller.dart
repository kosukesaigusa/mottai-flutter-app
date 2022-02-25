import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/controllers/map/map_page_state.dart';
import 'package:mottai_flutter_app_models/models.dart';

final mapPageController = StateNotifierProvider<MapPageController, MapPageState>(
  (ref) => MapPageController(),
);

class MapPageController extends StateNotifier<MapPageState> {
  MapPageController() : super(const MapPageState());

  void updateLocations(List<HostLocation> locations) {
    state = state.copyWith(locations: locations);
  }

  void updateLocations2(List<GeoPoint> locations2) {
    state = state.copyWith(locations2: locations2);
  }
}

// const double stackedGreyBackgroundHeight = 200;
// const double stackedGreyBackgroundBorderRadius = 36;
// const double stackedGreyBackgroundPaddingTop = 8;
// const double pageViewHeight = 148;
// const double pageViewHorizontalMargin = 4;
// const double pageViewVerticalMargin = 8;
// const double pageViewHorizontalPadding = 8;
// const double pageViewVerticalPadding = 16;
// const double pageViewBorderRadius = 16;
// const double pageViewImageBorderRadius = 16;
// const double nearMeCircleSize = 32;
// const double nearMeIconSize = 20;

// class MapPage extends StatefulHookConsumerWidget {
//   const MapPage({Key? key}) : super(key: key);

//   static const path = '/map/';
//   static const name = 'MapPage';

//   @override
//   ConsumerState<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends ConsumerState<MapPage> {
//   // final kagurazakaLatLng = const LatLng(35.7015, 139.7403);
//   final kagurazakaLatLng = const LatLng(35.7015, 137.923);
//   final radius = BehaviorSubject<double>.seeded(1);
//   final pageController = PageController(viewportFraction: 0.85);
//   late GoogleMapController mapController;
//   late Geoflutterfire geo;
//   late Stream<List<DocumentSnapshot<HostLocation>>> hostLocationsStream;
//   late Stream<List<DocumentSnapshot<Map<String, dynamic>>>> locationsStream;

//   @override
//   void initState() {
//     super.initState();
//     geo = Geoflutterfire();
//     final center = geo.point(
//       latitude: kagurazakaLatLng.latitude,
//       longitude: kagurazakaLatLng.longitude,
//     );
//     hostLocationsStream = radius.switchMap((radius) {
//       return geo
//           .collectionWithConverter(collectionRef: HostLocationRepository.hostLocationsRef)
//           .within(
//             center: center,
//             radius: radius,
//             field: 'position',
//             geopointFrom: (hostLocation) => hostLocation.position.geopoint,
//           );
//     });
//     locationsStream = radius.switchMap((radius) {
//       return geo.collection(collectionRef: db.collection('locations')).within(
//             center: center,
//             radius: radius,
//             field: 'position',
//           );
//     });
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     mapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // return;
//           await _setSeedLocationData();
//         },
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             onMapCreated: onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: kagurazakaLatLng,
//               zoom: 15,
//             ),
//             // markers: Set<Marker>.of(markers.values),
//             markers: Set<Marker>.of(
//               ref.watch(mapPageController).locations.map((l) {
//                 final lat = l.position.geopoint.latitude;
//                 final lng = l.position.geopoint.longitude;
//                 return Marker(
//                   markerId: MarkerId(lat.toString() + lng.toString()),
//                   position: LatLng(lat, lng),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//                   onTap: () {},
//                 );
//               }),
//             ),

//             //     Set<Marker>.of(
//             //   ref.watch(mapPageController).locations2.map((l) {
//             //     final lat = l.latitude;
//             //     final lng = l.longitude;
//             //     return Marker(
//             //       markerId: MarkerId(lat.toString() + lng.toString()),
//             //       position: LatLng(lat, lng),
//             //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//             //       onTap: () {},
//             //     );
//             //   }),
//             // ),
//           ),
//           _buildStackedGreyBackGround,
//           _buildStackedPageViewWidget,
//         ],
//       ),
//     );
//   }

//   /// Stack で重ねている画面下部のグレー背景部分
//   Widget get _buildStackedGreyBackGround => Positioned(
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: stackedGreyBackgroundHeight,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Colors.black26,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(stackedGreyBackgroundBorderRadius),
//                 topRight: Radius.circular(stackedGreyBackgroundBorderRadius),
//               ),
//             ),
//           ),
//         ),
//       );

//   /// Stack で重ねている PageView と near_me アイコン部分
//   Widget get _buildStackedPageViewWidget => Positioned(
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(right: 32),
//                 width: nearMeCircleSize,
//                 height: nearMeCircleSize,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 child: GestureDetector(
//                   onTap: _showHome,
//                   child: const Icon(
//                     Icons.near_me,
//                     size: nearMeIconSize,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const Gap(pageViewVerticalMargin),
//               SizedBox(
//                 height: stackedGreyBackgroundHeight -
//                     pageViewVerticalMargin * 2 -
//                     nearMeCircleSize -
//                     stackedGreyBackgroundPaddingTop,
//                 child: PageView(
//                   controller: pageController,
//                   physics: const ClampingScrollPhysics(),
//                   children: [
//                     for (final index in List<int>.generate(10, (i) => i)) _buildPageItem(index),
//                   ],
//                 ),
//               ),
//               const Gap(pageViewVerticalMargin),
//             ],
//           ),
//         ),
//       );

//   /// PageView のアイテム
//   Widget _buildPageItem(int index) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: pageViewHorizontalMargin),
//       padding: const EdgeInsets.symmetric(
//         horizontal: pageViewHorizontalPadding,
//         vertical: pageViewVerticalPadding,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(pageViewBorderRadius)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width / 4,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(pageViewImageBorderRadius),
//                 child: Image.network(
//                   'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
//                 ),
//               ),
//             ),
//           ),
//           const Gap(8),
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('${index + 1} 番目のホスト', style: bold14),
//                 const Gap(4),
//                 Text(
//                   '神奈川県小田原市でみかんを育てています！'
//                   'みかん収穫のお手伝いをしてくださる方募集中です🍊'
//                   'ぜひお気軽にマッチングリクエストお願いします！',
//                   style: grey12,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 3,
//                 ),
//                 const Spacer(),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       size: 18,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     Text(
//                       '神奈川県小田原市247番3',
//                       style: grey12,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Map の初回描画時に実行する
//   void onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     hostLocationsStream.listen(_updateMarkers);
//     // locationsStream.listen(_updateMarkers2);
//   }

//   /// locations コレクションの位置情報リストを取得し、そのそれぞれに対して
//   /// _addMarker() メソッドをコールして状態変数に格納する
//   void _updateMarkers(List<DocumentSnapshot<HostLocation>> hostLocations) {
//     final state = ref.watch(mapPageController);
//     final locations = state.locations;
//     for (final hostLocation in hostLocations) {
//       final data = hostLocation.data();
//       if (data == null) {
//         continue;
//       }
//       locations.add(data);
//     }
//     ref.watch(mapPageController.notifier).updateLocations(locations);
//   }

//   void _updateMarkers2(List<DocumentSnapshot<Map<String, dynamic>>> locations) {
//     final state = ref.watch(mapPageController);
//     final locations2 = state.locations2;
//     for (final l in locations2) {
//       final data = l;
//       locations2.add(data);
//     }
//     ref.watch(mapPageController.notifier).updateLocations2(locations2);
//   }

//   /// 受け取った緯度・経度の Marker オブジェクトインスタンスを生成して
//   /// その位置情報を状態変数の Map に格納する。
//   /// 緯度・経度の組をもとにした ID をキーにMap 型で取り扱っているので
//   /// Marker が重複することはない。
//   void _addMarker(double lat, double lng) {
//     // final id = MarkerId(lat.toString() + lng.toString());
//     // final _marker = Marker(
//     //   markerId: id,
//     //   position: LatLng(lat, lng),
//     //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     //   onTap: () {},
//     // );
//     // final marker = Marker(
//     //   markerId: id,
//     //   position: LatLng(lat, lng),
//     //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     //   onTap: () {},
//     // );
//   }

//   void _showHome() {
//     mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: kagurazakaLatLng,
//           zoom: 15,
//         ),
//       ),
//     );
//   }

//   Future<void> _setSeedLocationData() async {
//     for (var i = 0; i < 1; i++) {
//       final hostLocationId = uuid;
//       final random = Random();
//       const minLatitude = 20.2531;
//       const maxLatitude = 35.5354;
//       const minLongitude = 136.0411;
//       const maxLongitude = 139.0106;
//       final f1 = random.nextDouble();
//       final f2 = random.nextDouble();
//       final latitude = minLatitude + (maxLatitude - minLatitude) * f1;
//       final longitude = minLongitude + (maxLongitude - minLongitude) * f2;
//       final geopoint = GeoPoint(latitude, longitude);
//       final geohash = GeoHash.fromDecimalDegrees(longitude, latitude).geohash;
//       final hostLocation = HostLocation(
//         hostLocationId: hostLocationId,
//         title: '${i + 1} 番目のホスト',
//         hostId: uuid,
//         address: '東京都あいうえお区かきくけこ1-2-3',
//         description: '神奈川県小田原市でみかんを育てています！'
//             'みかん収穫のお手伝いをしてくださる方募集中です🍊'
//             'ぜひお気軽にマッチングリクエストお願いします！',
//         imageURL: 'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
//         position: Position(
//           geohash: geohash,
//           geopoint: geopoint,
//         ),
//       );
//       await HostLocationRepository.hostLocationRef(
//         hostLocationId: hostLocationId,
//       ).set(hostLocation);
//       await db.collection('locations').doc(hostLocationId).set(<String, dynamic>{
//         'position': <String, dynamic>{
//           'geohash': geohash,
//           'geopoint': geopoint,
//         }
//       });
//     }
//   }
// }
