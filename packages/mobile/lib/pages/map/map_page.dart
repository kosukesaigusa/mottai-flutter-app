import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app/theme/theme.dart';
import 'package:mottai_flutter_app/utils/utils.dart';
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

  final radius = BehaviorSubject<double>.seeded(1);
  final markers = <MarkerId, Marker>{};
  final kagurazakaLatLng = const LatLng(35.7015, 139.7403);

  late Stream<List<DocumentSnapshot>> stream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    geo = Geoflutterfire();
    final center = geo.point(latitude: 35.7015, longitude: 139.7403);
    stream = radius.switchMap((rad) {
      final collectionReference = db.collection('locations');
      return geo
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: rad, field: 'position', strictMode: true);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
          _buildStackedGreyBackGround,
          _buildStackedPageViewWidget,
        ],
      ),
    );
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      stream.listen(_updateMarkers);
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
      final data = document.data() as Map<String, dynamic>?;
      if (data == null) {
        continue;
      }
      final point = data['position']['geopoint'] as GeoPoint;
      _addMarker(point.latitude, point.longitude);
    }
  }

  void changed(double value) {
    setState(markers.clear);
    radius.add(value);
  }
}
