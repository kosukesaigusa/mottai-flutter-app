import 'dart:async';

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
import '../../job/ui/job_detail.dart';
import '../../user/host.dart';
import 'geolocator_controller.dart';

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
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'map';

  /// [MapPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  /// [GoogleMap] ウィジェットの `onMapCreated` で得られるコントローラインスタンス。
  late final GoogleMapController _googleMapController;

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

  /// [HostLocation] の取得結果の [StreamSubscription].
  /// [GoogleMap] ウィジェットの `onMapCreated` で初期化され、[dispose] メソッド
  /// でキャンセルされる。
  StreamSubscription<List<DocumentSnapshot<ReadHostLocation>>>?
      _streamSubscription;

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
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              _streamSubscription =
                  _stream.listen(_updateMarkersByDocumentSnapshots);
            },
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
          // TODO: 検出半径を変更する UI/UX はどうあるべきか考えて、実装する。
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.075,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Slider(
                              value: _radiusInKm,
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: _radiusInKm.toStringAsFixed(1),
                              onChanged: (value) => _geoQueryCondition.add(
                                _GeoQueryCondition(
                                  radiusInKm: value,
                                  cameraPosition: _cameraPosition,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      IconButton(
                        onPressed: () async {
                          final position = await ref
                              .read(currentLocationControllerProvider)
                              .getCurrentPosition();
                          if (position == null) {
                            return;
                          }
                          await _googleMapController.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(
                                position.latitude,
                                position.longitude,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.near_me),
                      )
                    ],
                  ),
                ),
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
    // TODO: 表示する [HostLocation] がない場合の UI を考える。
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          readHost.displayName,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (readJob != null)
                        ElevatedButton(
                          onPressed: () => context.router.pushNamed(
                            JobDetailPage.location(jobId: readJob.jobId),
                          ),
                          child: const Text('もっと見る'),
                        ),
                    ],
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
                      maxLines: 2,
                    )
                  else
                    const Text('まだこのホストのお手伝いは募集されていません。'),
                ],
              ),
      ),
    );
  }
}
