import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

import '../json_converters/host_types.dart';

part 'host.flutterfire_gen.dart';

@FirestoreDocument(path: 'hosts', documentName: 'host')
class Host {
  const Host({
    required this.displayName,
    this.imageUrl = '',
    this.hostTypes = const <HostType>{},
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  @ReadDefault('')
  final String displayName;

  final String imageUrl;

  @hostTypesConverter
  final Set<HostType> hostTypes;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @sealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  final SealedTimestamp createdAt;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @alwaysUseServerTimestampSealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  @UpdateDefault(ServerTimestamp())
  final SealedTimestamp updatedAt;
}

enum HostType {
  farmer('農家'),
  fisherman('漁師'),
  hunter('猟師'),
  other('その他'),
  ;

  const HostType(this.label);

  /// 与えられた文字列に対応する [HostType] を返す。
  factory HostType.fromString(String hostTypeString) {
    switch (hostTypeString) {
      case 'farmer':
        return HostType.farmer;
      case 'fisherman':
        return HostType.fisherman;
      case 'hunter':
        return HostType.hunter;
      case 'other':
        return HostType.other;
    }
    throw ArgumentError('ホスト種別が正しくありません。');
  }

  /// ホスト種別の表示名。
  final String label;
}
