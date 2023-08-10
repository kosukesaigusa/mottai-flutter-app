import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

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

class MapPage extends StatefulWidget {
  const MapPage({super.key});

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

  /// ジオクエリーの検出半径（km）。
  /// MEMO: 一旦は10kmで表示。
  static const double _initialRadiusInKm = 10;

  /// [BehaviorSubject]には、現在のジオクエリー半径とカメラ位置を指定。
  final _geoQueryCondition = BehaviorSubject<_GeoQueryCondition>.seeded(
    _GeoQueryCondition(
      radiusInKm: _initialRadiusInKm,
      cameraPosition: _initialCameraPosition,
    ),
  );

  /// ジオクエリー結果は[Stream]で取得。
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

  /// フェッチされた位置情報[DocumentSnapshot]によって[_markers]を更新。
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

  /// 取得した位置情報で[Marker]を作成。
  Marker _createMarker({
    required String id,
    required String hostId,
    required GeoPoint geoPoint,
  }) =>
      Marker(
        markerId: MarkerId('(${geoPoint.latitude}, ${geoPoint.longitude})'),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        infoWindow: InfoWindow(title: hostId),
        onTap: () {},
        // MEMO: マーカーにTapした時、Card swipe処理を実装する。
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
      /// MEMO: AppBarもボトムナビゲーションと同様に共通化するはずなので、表面上だけ実装
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.menu),
        title: const Text('探す'),
        actions: const [
          Icon(Icons.notifications_none_outlined),
        ],
      ),
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
              height: 220,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: _HostLocationPageView(
                readHostLocations: _readHostLocations,
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}

class _HostLocationPageView extends ConsumerWidget {
  const _HostLocationPageView({required this.readHostLocations});

  final List<ReadHostLocation> readHostLocations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: readHostLocations.length,
      itemBuilder: (context, index) {
        final readHostLocation = readHostLocations[index];
        return _HostLocationPageViewItem(readHostLocation: readHostLocation);
      },
    );
  }
}

// ===========================================
/// PageViewで表示するCard
class _HostLocationPageViewItem extends ConsumerWidget {
  const _HostLocationPageViewItem({required this.readHostLocation});

  final ReadHostLocation readHostLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostId = readHostLocation.hostId;

    final host = ref.watch(hostFutureProvider(hostId)).whenOrNull(
          data: (host) => host,
        );

    if (host == null) {
      // MEMO: リフレッシュ動作か、取得に失敗したことを表示する？
      return const SizedBox();
    } else {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ホスト名
                Text(
                  host.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        // ホスト画像
                        GenericImage.square(
                          imageUrl: host.imageUrl,
                          size: 70,
                          borderRadius: 8,
                        ),

                        const SizedBox(width: 8),

                        // 住所
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                readHostLocation.address,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),

                              // ホストType
                              SelectableChips<HostType>(
                                padding: 0,
                                allItems: host.hostTypes,
                                labels: Map.fromEntries(
                                  host.hostTypes.map(
                                    (type) => MapEntry(type, type.label),
                                  ),
                                ),
                                enabledItems: host.hostTypes,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 詳細分
                // TODO: job.jobDetail を取得して表示する
                Text(
                  'job.jobDetail \njob.jobDetail \njob.jobDetail ddgegegegegegegegegegegegegeggegegegegege ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
