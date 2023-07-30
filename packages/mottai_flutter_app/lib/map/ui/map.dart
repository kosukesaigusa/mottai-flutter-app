import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// Tokyo Station location for demo.
const _tokyoStation = LatLng(35.681236, 139.767125);

/// Reference to the collection where the location data is stored.
/// `withConverter` is available to type-safely define [CollectionReference].
final _collectionReference = FirebaseFirestore.instance.collection('locations');

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

/// Example page using [GoogleMap].
class MapPageState extends State<MapPage> {
  /// [Marker]s on Google Maps.
  Set<Marker> _markers = {};

  /// [BehaviorSubject] of currently geo query radius and camera position.
  final _geoQueryCondition = BehaviorSubject<_GeoQueryCondition>.seeded(
    _GeoQueryCondition(
      radiusInKm: _initialRadiusInKm,
      cameraPosition: _initialCameraPosition,
    ),
  );

  /// [Stream] of geo query result.
  late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> _stream =
      _geoQueryCondition.switchMap(
    (geoQueryCondition) =>
        GeoCollectionReference(_collectionReference).subscribeWithin(
      center: GeoFirePoint(
        GeoPoint(
          _cameraPosition.target.latitude,
          _cameraPosition.target.longitude,
        ),
      ),
      radiusInKm: geoQueryCondition.radiusInKm,
      field: 'geo',
      geopointFrom: (data) =>
          (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
      strictMode: true,
    ),
  );

  /// Updates [_markers] by fetched geo [DocumentSnapshot]s.
  void _updateMarkersByDocumentSnapshots(
    List<DocumentSnapshot<Map<String, dynamic>>> documentSnapshots,
  ) {
    final markers = <Marker>{};
    for (final ds in documentSnapshots) {
      final id = ds.id;
      final data = ds.data();
      if (data == null) {
        continue;
      }
      final name = data['name'] as String;
      final geoPoint =
          (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
      markers.add(_createMarker(id: id, name: name, geoPoint: geoPoint));
    }
    debugPrint('📍 markers count: ${markers.length}');
    setState(() {
      _markers = markers;
    });
  }

  /// Creates a [Marker] by fetched geo location.
  Marker _createMarker({
    required String id,
    required String name,
    required GeoPoint geoPoint,
  }) =>
      Marker(
        markerId: MarkerId('(${geoPoint.latitude}, ${geoPoint.longitude})'),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        infoWindow: InfoWindow(title: name),
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => SetOrDeleteLocationDialog(
            id: id,
            name: name,
            geoFirePoint: GeoFirePoint(
              GeoPoint(geoPoint.latitude, geoPoint.longitude),
            ),
          ),
        ),
      );

  /// Current detecting radius in kilometers.
  double get _radiusInKm => _geoQueryCondition.value.radiusInKm;

  /// Current camera position on Google Maps.
  CameraPosition get _cameraPosition => _geoQueryCondition.value.cameraPosition;

  /// Initial geo query detection radius in km.
  /// TODO: サークルとか表示しないので、どの範囲を初期値で表示するかを確認する。
  static const double _initialRadiusInKm = 100;

  /// Google Maps initial camera zoom level.
  static const double _initialZoom = 14;

  /// Google Maps initial target position.
  static final LatLng _initialTarget = LatLng(
    _tokyoStation.latitude,
    _tokyoStation.longitude,
  );

  /// Google Maps initial camera position.
  static final _initialCameraPosition = CameraPosition(
    target: _initialTarget,
    zoom: _initialZoom,
  );

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
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(Icons.notifications_none_outlined)),
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
            onCameraMove: (cameraPosition) {
              debugPrint('📷 lat: ${cameraPosition.target.latitude}, '
                  'lng: ${cameraPosition.target.latitude}');
              _geoQueryCondition.add(
                _GeoQueryCondition(
                  radiusInKm: _radiusInKm,
                  cameraPosition: cameraPosition,
                ),
              );
            },

            /// MEMO: testデータ登録用で手軽に登録できるためコメントアウト
            // onLongPress: (latLng) => showDialog<void>(
            //   context: context,
            //   builder: (context) => AddLocationDialog(latLng: latLng),
            // ),
          ),

          // TODO: PageView.builderに変更する
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: PageView(
                controller: PageController(viewportFraction: 0.85),
                children: const [
                  CustomCard(
                    hostName: '矢郷史郎 (host.displayName)',
                    address: '神奈川県小田原市石322（最大2行まで。hostLocation.address)',
                    jobTypes: ['農家', '農家'],
                    details:
                        'みかんの収穫や、その他、農作業全般の体験・お手伝いをしてくれる方を募集します！(job.description)\n内容が長くて入り切らない場合は、末尾は...にする',
                  ),
                  CustomCard(
                    hostName: '矢郷史郎 (host.displayName)',
                    address: '神奈川県小田原市石322（最大2行まで。hostLocation.address)',
                    jobTypes: ['農家', '農家'],
                    details:
                        'みかんの収穫や、その他、農作業全般の体験・お手伝いをしてくれる方を募集します！(job.description)\n内容が長くて入り切らない場合は、末尾は...にする',
                  ),
                  CustomCard(
                    hostName: '矢郷史郎 (host.displayName)',
                    address: '神奈川県小田原市石322（最大2行まで。hostLocation.address)',
                    jobTypes: ['農家', '農家'],
                    details:
                        'みかんの収穫や、その他、農作業全般の体験・お手伝いをしてくれる方を募集します！(job.description)\n内容が長くて入り切らない場合は、末尾は...にする',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================
/// ListViewで表示するCard
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
  final List<String> jobTypes;
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
                                        jobType,
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

/// ==============================================================
///MEMO: testデータ登録用

/// AlertDialog widget to add location data to Cloud Firestore.
class SetOrDeleteLocationDialog extends StatelessWidget {
  const SetOrDeleteLocationDialog({
    super.key,
    required this.id,
    required this.name,
    required this.geoFirePoint,
  });

  final String id;
  final String name;
  final GeoFirePoint geoFirePoint;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text('Enter location data'),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => null,
            child: const Text('set location'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => null,
            child: const Text('delete location'),
          ),
        ],
      ),
    );
  }
}

class AddLocationDialog extends StatefulWidget {
  const AddLocationDialog({super.key, this.latLng});

  final LatLng? latLng;

  @override
  AddLocationDialogState createState() => AddLocationDialogState();
}

class AddLocationDialogState extends State<AddLocationDialog> {
  final _nameEditingController = TextEditingController();
  final _latitudeEditingController = TextEditingController();
  final _longitudeEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.latLng != null) {
      _latitudeEditingController.text = widget.latLng!.latitude.toString();
      _longitudeEditingController.text = widget.latLng!.longitude.toString();
    }
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _latitudeEditingController.dispose();
    _longitudeEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text('Enter location data'),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameEditingController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: const Text('name'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _latitudeEditingController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: const Text('latitude'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _longitudeEditingController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: const Text('longitude'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final name = _nameEditingController.value.text;
              if (name.isEmpty) {
                throw Exception('Enter valid name');
              }
              final latitude =
                  double.tryParse(_latitudeEditingController.value.text);
              final longitude =
                  double.tryParse(_longitudeEditingController.value.text);
              if (latitude == null || longitude == null) {
                throw Exception(
                  'Enter valid values as latitude and longitude.',
                );
              }
              try {
                await _addLocation(
                  name,
                  latitude,
                  longitude,
                );
              } on Exception catch (e) {
                debugPrint(
                  '🚨 An exception occurred when adding location data $e',
                );
              }
              navigator.pop();
            },
            child: const Text('Add location data'),
          ),
        ],
      ),
    );
  }

  /// Adds location data to Cloud Firestore.
  Future<void> _addLocation(
    String name,
    double latitude,
    double longitude,
  ) async {
    final geoFirePoint = GeoFirePoint(GeoPoint(latitude, longitude));
    await GeoCollectionReference<Map<String, dynamic>>(
      FirebaseFirestore.instance.collection('locations'),
    ).add(<String, dynamic>{
      'geo': geoFirePoint.data,
      'name': name,
      'isVisible': true,
    });
    debugPrint(
      '🌍 Location data is successfully added: '
      'name: $name'
      'lat: $latitude, '
      'lng: $longitude, '
      'geohash: ${geoFirePoint.geohash}',
    );
  }
}
