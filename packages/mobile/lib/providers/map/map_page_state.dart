import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../utils/geo.dart';

part 'map_page_state.freezed.dart';

@freezed
class MapPageState with _$MapPageState {
  const factory MapPageState({
    @Default(false) bool ready,
    @Default(initialRadius) int debugRadius,
    @Default(initialZoomLevel) double debugZoomLevel,
    @Default(true) bool resetDetection,
    @Default(<MarkerId, Marker>{}) Map<MarkerId, Marker> markers,
    @Default(<HostLocation>[]) List<HostLocation> hostLocationsOnMap,
    @Default(initialLocation) LatLng center,
    HostLocation? selectedHostLocation,
  }) = _MapPageState;
}
