import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job.flutterfire_gen.dart';

@FirestoreDocument(path: 'jobs', documentName: 'job')
class Job {
  const Job({
    required this.hostId,
    required this.imageUrl,
    required this.title,
    required this.place,
    required this.content,
    required this.belongings,
    required this.reward,
    required this.accessDescription,
    required this.accessTypes,
    this.comment = '',
    this.createdAt,
    this.updatedAt,
  });

  final String hostId;

  @ReadDefault('')
  @CreateDefault('')
  final String imageUrl;

  @ReadDefault('')
  final String title;

  @ReadDefault('')
  final String place;

  @ReadDefault('')
  final String content;

  @ReadDefault('')
  final String belongings;

  @ReadDefault('')
  final String reward;

  @ReadDefault('')
  @CreateDefault('')
  final String accessDescription;

  @ReadDefault(<AccessType>{})
  @CreateDefault(<AccessType>{})
  @_accessTypesConverter
//   @TranslateJsonConverterToTypeScript(
//     fromJson: '''
// (accessTypes: unknown[] | undefined): Set<AccessType> {
//   return new Set((accessTypes ?? []).map((e) => e as AccessType))
// }
// ''',
//     toJson: '''
// (accessTypes: Set<AccessType>): string[] {
//   return [...accessTypes]
// }
// ''',
//   )
  final Set<AccessType> accessTypes;

  @ReadDefault('')
  @CreateDefault('')
  final String comment;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}

/// 仕事の場所へのアクセスの種類。
// @TranslateToTypeScript(isEnum: true)
enum AccessType {
  trainAvailable('電車あり'),
  busAvailable('バスあり'),
  parkingAvailable('駐車場あり'),
  walkableFromNearest('最寄りから徒歩可能'),
  shuttleServiceAvailable('最寄りから送迎可能'),
  ;

  // NOTE: ここで enhanced enum で label を定義するのは、Model に View の情報を
  // 記述しているようで少し違和感もあるが、View で enum の extension を定義するのも
  // 冗長に思えるのでこのようにしている。
  const AccessType(this.label);

  /// 与えられた文字列に対応する [AccessType] を返す。
  factory AccessType.fromString(String accessTypeString) {
    switch (accessTypeString) {
      case 'trainAvailable':
        return AccessType.trainAvailable;
      case 'busAvailable':
        return AccessType.busAvailable;
      case 'parkingAvailable':
        return AccessType.parkingAvailable;
      case 'walkableFromNearest':
        return AccessType.walkableFromNearest;
      case 'shuttleServiceAvailable':
        return AccessType.shuttleServiceAvailable;
    }
    throw ArgumentError('アクセス種別が正しくありません。');
  }

  /// アクセスタイプの表示文字列。
  final String label;
}

const _accessTypesConverter = _AccessTypesConverter();

class _AccessTypesConverter
    implements JsonConverter<Set<AccessType>, List<dynamic>?> {
  const _AccessTypesConverter();

  @override
  Set<AccessType> fromJson(List<dynamic>? json) =>
      (json ?? []).map((e) => AccessType.fromString(e as String)).toSet();

  @override
  List<String> toJson(Set<AccessType> accessTypes) =>
      accessTypes.map((a) => a.name).toList();
}
