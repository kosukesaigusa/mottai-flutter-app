import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rxdart/rxdart.dart';

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
  /// Google Mapに記される[Marker]。
  Set<Marker> _markers = {};

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
    for (final ds in documentSnapshots) {
      final id = ds.id;
      final location = ds.data();
      if (location == null) {
        continue;
      }
      final hostId = location.hostId;
      final geoPoint = location.geo.geopoint;
      markers.add(_createMarker(id: id, hostId: hostId, geoPoint: geoPoint));
    }
    setState(() {
      _markers = markers;
    });
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
        onTap: () => null,
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
              height: 250,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: StreamBuilder(
                // MEMO: 用意されてるメソッドがあるはずなのでそれを使う。
                // StreamBuilderでPageViewを表示するのが微妙な気がする。
                stream: readHostCollectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('エラーが発生しました'));
                  } else {
                    return PageView.builder(
                      // MEMO: カードスワイプした際に、カメラ位置を更新する。
                      // onPageChanged: (index) {
                      //   final _currentHostId =
                      //       snapshot.data!.docs[index].data().hostId;
                      //   // _currentHostIdと一致するドキュメントを取得する。
                      //   _stream.listen(
                      //     (documentSnapshots) {
                      //       final currentHostLocation = documentSnapshots
                      //           .firstWhere(
                      //             (documentSnapshot) =>
                      //                 documentSnapshot.data()!.hostId ==
                      //                 _currentHostId,
                      //           )
                      //           .data();

                      //       _geoQueryCondition.add(
                      //         _GeoQueryCondition(
                      //           radiusInKm: _radiusInKm,
                      //           cameraPosition: CameraPosition(
                      //             target: LatLng(
                      //               currentHostLocation!.geo.geopoint.latitude,
                      //               currentHostLocation.geo.geopoint.longitude,
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   );
                      // },
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final host = snapshot.data!.docs[index].data();
                        return CustomCard(
                          // MEMO: imageUrlも追加して画像を表示する。
                          hostName: host.displayName,
                          address: 'ああああああああ',
                          jobTypes: host.hostTypes,
                          details:
                              'みかんの収穫や、その他、農作業全般の体験・お手伝いをしてくれる方を募集します！(job.description)\n内容が長くて入り切らない場合は、末尾は...にする',
                        );
                      },
                    );
                  }
                },
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

// ===========================================
/// PageViewで表示するCard
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.hostName,
    required this.address,
    required this.jobTypes,
    required this.details,
  });

  final String hostName;
  final String address;
  final Set<HostType> jobTypes;
  final String details;

  @override
  Widget build(BuildContext context) {
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
              // ホスト名Part
              Text(hostName, style: Theme.of(context).textTheme.titleMedium),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      // 画像Part
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 住所Part
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                              maxLines: 2,
                            ),

                            // Tag Part
                            // MEMO: ContainerではなくてtagのWidgetを使用する。
                            Row(
                              children: jobTypes.map((jobType) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    right: 8,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.purple[100],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        jobType.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 詳細分Part
              Text(
                details,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
