import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:mottai_flutter_app_models/models.dart';

import 'geo.dart';
import 'utils.dart';

/// シードデータを作成する
Future<void> setSeedLocationData() async {
  final batch = db.batch();
  for (var i = 0; i < 100; i++) {
    final hostLocationId = uuid;
    final random = Random();
    // 日本
    // final minLatitude = doubleFromDegree(degree: 33, minute: 13, second: 04);
    // final maxLatitude = doubleFromDegree(degree: 43, minute: 23, second: 06);
    // final minLongitude = doubleFromDegree(degree: 129, minute: 33, second: 09);
    // final maxLongitude = doubleFromDegree(degree: 145, minute: 48, second: 58);
    // 小田原市
    final minLatitude = doubleFromDegree(degree: 35, minute: 10, second: 41);
    final maxLatitude = doubleFromDegree(degree: 35, minute: 19, second: 48);
    final minLongitude = doubleFromDegree(degree: 139, minute: 03, second: 37);
    final maxLongitude = doubleFromDegree(degree: 139, minute: 14, second: 18);
    final f1 = random.nextDouble();
    final f2 = random.nextDouble();
    final latitude = minLatitude + (maxLatitude - minLatitude) * f1;
    final longitude = minLongitude + (maxLongitude - minLongitude) * f2;
    final geoFirePoint = Geoflutterfire().point(latitude: latitude, longitude: longitude);
    final hostLocation = HostLocation(
      hostLocationId: uuid,
      title: 'ホスト：${uuid.substring(0, 15)}',
      hostId: uuid,
      address: '東京都あいうえお区かきくけこ1-2-3',
      description: '神奈川県小田原市でみかんを育てています！'
          'みかん収穫のお手伝いをしてくださる方募集中です🍊'
          'ぜひお気軽にマッチングリクエストお願いします！',
      imageURL: 'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
      position: FirestorePosition(
        geohash: geoFirePoint.data['geohash'] as String,
        geopoint: geoFirePoint.data['geopoint'] as GeoPoint,
      ),
    );
    // await HostLocationRepository.hostLocationRef(
    //   hostLocationId: hostLocationId,
    // ).set(hostLocation);
    batch.set(
      HostLocationRepository.hostLocationRef(hostLocationId: hostLocationId),
      hostLocation,
    );
    debugPrint('${i + 1} 番目書き込み完了');
  }
  await batch.commit();
  debugPrint('バッチコミットしました');
}
