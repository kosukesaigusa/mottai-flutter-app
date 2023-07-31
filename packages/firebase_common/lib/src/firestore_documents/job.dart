import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job.flutterfire_gen.dart';

@FirestoreDocument(path: 'jobs', documentName: 'jobs')
class Job {
  const Job({
    required this.hostId,
    required this.title,
    required this.content,
    required this.place,
    this.accessTypes = const <AccessType>{},
    this.accessDescription = '',
    required this.belongings,
    required this.reward,
    this.comment = '',
    this.urls = const <String>[],
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;

  @ReadDefault('')
  final String title;

  @ReadDefault('')
  final String content;

  @ReadDefault('')
  final String place;

  @_accessTypesConverter
  final Set<AccessType> accessTypes;

  final String accessDescription;

  @ReadDefault('')
  final String belongings;

  @ReadDefault('')
  final String reward;

  final String comment;

  final List<String> urls;

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

/// 仕事の場所へのアクセスの種類。
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
