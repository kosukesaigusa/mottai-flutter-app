import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

import '../json_converters/access_type.dart';

part 'job.flutterfire_gen.dart';

@FirestoreDocument(path: 'jobs', documentName: 'hostLocation')
class Job {
  const Job({
    required this.hostId,
    this.content = '',
    this.place = '',
    this.accessTypes = const <AccessType>{},
    this.accessDescription = '',
    this.belongings = '',
    this.comment = '',
    this.urls = const <String>[],
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;

  final String content;

  final String place;

  final String belongings;

  final String comment;

  @accessTypesConverter
  final Set<AccessType> accessTypes;

  final String accessDescription;

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
  shuttleServiceAvailable('駅から送迎可能'),
  ;

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
    throw ArgumentError('アクセスタイプが正しくありません。');
  }

  /// アクセスタイプの表示文字列。
  final String label;
}
