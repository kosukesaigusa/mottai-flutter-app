import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  static const path = '/map/';
  static const name = 'MapPage';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  TextEditingController? _latitudeController, _longitudeController;

  final radius = BehaviorSubject<double>.seeded(1);
  final _firestore = FirebaseFirestore.instance;
  final markers = <MarkerId, Marker>{};
  final kagurazakaLatLng = const LatLng(35.7015, 139.7403);
  double _value = 20;
  String _label = '';

  late Stream<List<DocumentSnapshot>> stream;
  late Geoflutterfire geo;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    geo = Geoflutterfire();
    final center = geo.point(latitude: 35.7015, longitude: 139.7403);
    stream = radius.switchMap((rad) {
      final collectionReference = _firestore.collection('locations');
      return geo
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: rad, field: 'position', strictMode: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: kagurazakaLatLng,
          zoom: 15,
        ),
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mapController == null ? null : _showHome,
        child: const Icon(Icons.home),
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
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }
}
