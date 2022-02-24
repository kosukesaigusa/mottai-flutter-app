import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

part 'map_page_state.freezed.dart';

@freezed
class MapPageState with _$MapPageState {
  const factory MapPageState({
    @Default(true) bool loading,
    GeoFirePoint? center,
  }) = _MapPageState;
}
