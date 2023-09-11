import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// デバイス情報文字列を提供する [Provider].
final deviceInfoProvider = Provider<String>((_) => throw UnimplementedError());

/// デバイス情報を取得する。
Future<String> getDeviceInfo() async {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    const os = 'Android';
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    final osVersion = androidInfo.version.release;
    final device = androidInfo.device;
    return DeviceInfo(os: os, osVersion: osVersion, device: device).toString();
  } else if (Platform.isIOS) {
    const os = 'iOS';
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    final osVersion = iosInfo.systemVersion;
    final device = iosInfo.model;
    return DeviceInfo(os: os, osVersion: osVersion, device: device).toString();
  } else {
    throw UnimplementedError();
  }
}

class DeviceInfo {
  const DeviceInfo({
    required this.os,
    required this.osVersion,
    required this.device,
  });

  final String os;

  final String osVersion;

  final String device;

  @override
  String toString() => 'os: $os, osVersion: $osVersion, device: $device';
}
