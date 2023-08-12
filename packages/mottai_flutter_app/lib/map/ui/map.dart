import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../job/job.dart';
import '../../user/host.dart';

/// 東京駅の緯度経度（テスト用）初期位置は現在地？
const _tokyoStation = LatLng(35.681236, 139.767125);

/// Geo query geoQueryCondition.
class _GeoQueryCondition {
  _GeoQueryCondition({
    required this.radiusInKm,
    required this.cameraPosition,
  });

  final double radiusInKm;
  final CameraPosition cameraPosition;
}

@RoutePage()
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/map';

  /// [MapPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  /// Google Mapに記される [Marker].
  Set<Marker> _markers = {};

  /// 取得された [HostLocation] 一覧。
  List<ReadHostLocation> _readHostLocations = [];

  /// Googleマップの初期ターゲット位置。
  static final LatLng _initialTarget = LatLng(
    _tokyoStation.latitude,
    _tokyoStation.longitude,
  );

  /// Googleマップの初期カメラズームレベル。
  static const double _initialZoom = 14;

  /// Googleマップの初期カメラ位置。
  static final _initialCameraPosition = CameraPosition(
    target: _initialTarget,
    zoom: _initialZoom,
  );

  /// 検出半径（km）。
  static const double _initialRadiusInKm = 10;

  /// [HostLocation] の検出条件を与える [BehaviorSubject].
  final _geoQueryCondition = BehaviorSubject<_GeoQueryCondition>.seeded(
    _GeoQueryCondition(
      radiusInKm: _initialRadiusInKm,
      cameraPosition: _initialCameraPosition,
    ),
  );

  /// 現在の [_cameraPosition] と [_radiusInKm] によって [HostLocation] 一覧を取得する
  /// [Stream].
  late final Stream<List<DocumentSnapshot<ReadHostLocation>>> _stream =
      _geoQueryCondition.switchMap(
    (geoQueryCondition) =>
        GeoCollectionReference(readHostLocationCollectionReference)
            .subscribeWithin(
      center: GeoFirePoint(
        GeoPoint(
          _cameraPosition.target.latitude,
          _cameraPosition.target.longitude,
        ),
      ),
      radiusInKm: geoQueryCondition.radiusInKm,
      field: 'geo',
      geopointFrom: (location) => location.geo.geopoint,
      strictMode: true,
    ),
  );

  /// 取得された位置情報 [DocumentSnapshot] によって [_markers] を更新する。
  void _updateMarkersByDocumentSnapshots(
    List<DocumentSnapshot<ReadHostLocation>> documentSnapshots,
  ) {
    final markers = <Marker>{};
    final readHostLocations = <ReadHostLocation>[];
    for (final ds in documentSnapshots) {
      final id = ds.id;
      final readHostLocation = ds.data();
      if (readHostLocation == null) {
        continue;
      }
      final hostId = readHostLocation.hostId;
      final geoPoint = readHostLocation.geo.geopoint;
      markers.add(_createMarker(id: id, hostId: hostId, geoPoint: geoPoint));
      readHostLocations.add(readHostLocation);
    }
    _markers = markers;
    _readHostLocations = readHostLocations;
    setState(() {});
  }

  /// 取得した位置情報で [Marker] を作成する。
  Marker _createMarker({
    required String id,
    required String hostId,
    required GeoPoint geoPoint,
  }) =>
      Marker(
        markerId: MarkerId('(${geoPoint.latitude}, ${geoPoint.longitude})'),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        // TODO: onTap に PageView と連動する処理を實相する。
        // onTap: () {},
      );

  /// 現在の検出半径（km）。
  double get _radiusInKm => _geoQueryCondition.value.radiusInKm;

  /// Googleマップ上の現在のカメラ位置。
  CameraPosition get _cameraPosition => _geoQueryCondition.value.cameraPosition;

  @override
  void dispose() {
    _geoQueryCondition.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('探す')),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (_) =>
                _stream.listen(_updateMarkersByDocumentSnapshots),
            markers: _markers,
            circles: {
              Circle(
                circleId: const CircleId('value'),
                center: LatLng(
                  _cameraPosition.target.latitude,
                  _cameraPosition.target.longitude,
                ),
                // キロメートルからメートルに変換する場合は、1000の倍数を用いる。
                radius: _radiusInKm * 1000,
                fillColor: Colors.black12,
                strokeWidth: 0,
              ),
            },
            onCameraMove: (cameraPosition) {
              _geoQueryCondition.add(
                _GeoQueryCondition(
                  radiusInKm: _radiusInKm,
                  cameraPosition: cameraPosition,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 240,
              margin: const EdgeInsets.only(bottom: 32),
              child: _HostLocationPageView(
                readHostLocations: _readHostLocations,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HostLocationPageView extends ConsumerWidget {
  const _HostLocationPageView({required this.readHostLocations});

  final List<ReadHostLocation> readHostLocations;

  static const _viewportFraction = 0.85;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView.builder(
      controller: PageController(viewportFraction: _viewportFraction),
      itemCount: readHostLocations.length,
      itemBuilder: (context, index) => _HostLocationPageViewItem(
        readHostLocation: readHostLocations[index],
      ),
    );
  }
}

/// [PageView] で表示するカード上の UI.
class _HostLocationPageViewItem extends ConsumerWidget {
  const _HostLocationPageViewItem({required this.readHostLocation});

  final ReadHostLocation readHostLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostId = readHostLocation.hostId;
    final readHost = ref.watch(hostStreamProvider(hostId)).valueOrNull;
    final readJob = ref.watch(hostFirstJobFutureProvider(hostId));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: readHost == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ホストデータの取得に失敗しました。'),
                    Text(hostId, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    readHost.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const Gap(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericImage.square(
                        imageUrl: readHost.imageUrl,
                        size: 72,
                        borderRadius: 8,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              readHostLocation.address,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const Gap(4),
                            SelectableChips<HostType>(
                              padding: 0,
                              allItems: readHost.hostTypes,
                              labels: Map.fromEntries(
                                readHost.hostTypes.map(
                                  (type) => MapEntry(type, type.label),
                                ),
                              ),
                              enabledItems: readHost.hostTypes,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  if (readJob != null)
                    Text(
                      readJob.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  else
                    const Text('まだこのホストのお手伝いは募集されていません。'),
                ],
              ),
      ),
    );
  }
}

// MEMO: 位置情報取得実装部分。後にMergeする。

// Container(
//   margin: EdgeInsets.only(
//     bottom: MediaQuery.of(context).size.height * 0.1,
//   ),
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: GestureDetector(
//       onTap: () {
//         ref
//             .read(
//               currentLocationControllerProvider,
//             )
//             .getCurrentPosition();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 15,
//           vertical: 5,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.yellow,
//           border: Border.all(
//             color: Colors.white,
//           ),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               '現在地を取得',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ref.watch(currentPositionProvider).when(
//                   data: (position) => Text('''
//                     緯度: ${position.latitude}, 経度: ${position.longitude}
//                   '''),
//                   error: (_, __) => const SizedBox(),
//                   loading: () => const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     ),
//   ),
// ),
