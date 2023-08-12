import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// リクエストする権限の種類。
enum RequestedPermission {
  /// 端末の画像ライブラリへのアクセス。
  gallery,

  /// 端末のカメラへのアクセス。
  camera,

  /// 端末の位置情報へのアクセス。
  location,
}

/// 端末の画像ライブラリやカメラ、位置情報へのアクセスが許可されていない場合に表示する
/// [AlertDialog]. permission_handler パッケージの [openAppSettings] メソッドで
/// 設定画面に進ませる。
class AccessDeniedDialog extends StatelessWidget {
  const AccessDeniedDialog.gallery({super.key})
      : _requestedPermission = RequestedPermission.gallery;

  const AccessDeniedDialog.camera({super.key})
      : _requestedPermission = RequestedPermission.camera;

  const AccessDeniedDialog.location({super.key})
      : _requestedPermission = RequestedPermission.location;

  final RequestedPermission _requestedPermission;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('設定画面へ'),
          onPressed: () {
            Navigator.of(context).pop(false);
            openAppSettings();
          },
        ),
      ],
    );
  }

  String get _title {
    switch (_requestedPermission) {
      case RequestedPermission.gallery:
        return '端末の画像の使用が許可されていません。';
      case RequestedPermission.camera:
        return '端末のカメラの使用が許可されていません。';
      case RequestedPermission.location:
        return '端末の位置情報の使用が許可されていません。';
    }
  }

  String get _content {
    switch (_requestedPermission) {
      case RequestedPermission.gallery:
        return '端末の画像ライブラリの使用が許可されていません。'
            '端末の設定画面へ進み、画像ライブラリの使用を許可してください。';
      case RequestedPermission.camera:
        return 'カメラの使用が許可されていません。'
            '端末の設定画面へ進み、カメラの使用を許可してください。';
      case RequestedPermission.location:
        return '端末の位置情報の使用が許可されていません。'
            '端末の設定画面へ進み、位置情報の使用を許可してください。';
    }
  }
}
