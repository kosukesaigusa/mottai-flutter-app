import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// 端末の画像ライブラリやカメラへのアクセスが許可されていない場合に表示する
/// [AlertDialog]. permission_handler パッケージの [openAppSettings] メソッドで
/// 設定画面に進ませる。
class AccessNotDeniedDialog extends StatelessWidget {
  const AccessNotDeniedDialog.gallery({super.key})
      : _imageSource = ImageSource.gallery;

  const AccessNotDeniedDialog.camera({super.key})
      : _imageSource = ImageSource.camera;

  final ImageSource _imageSource;

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
    switch (_imageSource) {
      case ImageSource.gallery:
        return '端末の画像の使用が許可されていません。';
      case ImageSource.camera:
        return '端末のカメラの使用が許可されていません。';
    }
  }

  String get _content {
    switch (_imageSource) {
      case ImageSource.gallery:
        return '端末の画像ライブラリの使用が許可されていません。'
            '端末の設定画面へ進み、画像ライブラリの使用を許可してください。';
      case ImageSource.camera:
        return 'カメラの使用が許可されていません。'
            '端末の設定画面へ進み、カメラの使用を許可してください。';
    }
  }
}
