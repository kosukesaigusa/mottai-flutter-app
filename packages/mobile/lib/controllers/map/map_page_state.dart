import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:mottai_flutter_app_models/models.dart';

part 'map_page_state.freezed.dart';

@freezed
class MapPageState with _$MapPageState {
  const factory MapPageState({
    @Default(true) bool loading,
    GeoFirePoint? center,
    @Default(<HostLocation>[]) List<HostLocation> locations,
    @Default(<GeoPoint>[]) List<GeoPoint> locations2,
  }) = _MapPageState;
}
