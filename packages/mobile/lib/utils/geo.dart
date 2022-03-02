import 'package:google_maps_flutter/google_maps_flutter.dart';

const double viewportFraction = 0.85;
const int initialRadius = 300;
const double initialZoomLevel = 10;
const double minZoomLevel = 5;
const double maxZoomLevel = 17;
const initialLocation = LatLng(35.6812, 139.7671);

/// Zoom Level (5.0 <= x <= 17.0) から半径 km を取得する
double getRadiusFromZoom(double zoom) {
  if (zoom <= 6) {
    return 300;
  }
  if (zoom <= 7) {
    return 200;
  }
  if (zoom <= 8) {
    return 150;
  }
  if (zoom <= 9) {
    return 100;
  }
  if (zoom <= 10) {
    return 50;
  }
  if (zoom <= 11) {
    return 25;
  }
  if (zoom <= 12) {
    return 15;
  }
  if (zoom <= 13) {
    return 10;
  }
  if (zoom <= 14) {
    return 7;
  }
  if (zoom <= 15) {
    return 5;
  }
  if (zoom <= 16) {
    return 2;
  }
  return 1;
}

/// 度・分・秒 の緯度・経度を
double doubleFromDegree({required int degree, int minute = 0, int second = 0}) {
  return degree + minute / 60 + second / 60 / 60;
}
