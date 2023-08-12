import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host.flutterfire_gen.dart';

@FirestoreDocument(path: 'hosts', documentName: 'host')
class Host {
  const Host({
    required this.imageUrl,
    required this.displayName,
    required this.introduction,
    required this.hostTypes,
    required this.urls,
    this.createdAt,
    this.updatedAt,
  });

  @ReadDefault('')
  @CreateDefault('')
  final String imageUrl;

  @ReadDefault('')
  final String displayName;

  @ReadDefault('')
  final String introduction;

  @ReadDefault(<HostType>{})
  @_hostTypesConverter
  final Set<HostType> hostTypes;

  @ReadDefault(<String>[])
  @CreateDefault(<String>[])
  final List<String> urls;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}

enum HostType {
  farmer('農家'),
  fisherman('漁師'),
  hunter('猟師'),
  other('その他'),
  ;

  // NOTE: ここで enhanced enum で label を定義するのは、Model に View の情報を
  // 記述しているようで少し違和感もあるが、View で enum の extension を定義するのも
  // 冗長に思えるのでこのようにしている。
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

const _hostTypesConverter = _HostTypesConverter();

class _HostTypesConverter
    implements JsonConverter<Set<HostType>, List<dynamic>?> {
  const _HostTypesConverter();

  @override
  Set<HostType> fromJson(List<dynamic>? json) =>
      (json ?? []).map((e) => HostType.fromString(e as String)).toSet();

  @override
  List<String> toJson(Set<HostType> hostTypes) =>
      hostTypes.map((a) => a.name).toList();
}
