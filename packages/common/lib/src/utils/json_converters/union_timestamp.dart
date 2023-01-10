import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'union_timestamp.freezed.dart';

/// UnionTimeStamp の JsonConverter。
const unionTimestampConverter = _UnionTimestampConverter();

/// toJson（Firestore への書き込み）時に、常に FieldValue.serverTimestamp を使用する
/// UnionTimeStamp の JsonConverter。
const alwaysUseServerTimestampUnionTimestampConverter =
    _UnionTimestampConverter(alwaysUseServerTimestamp: true);

class _UnionTimestampConverter implements JsonConverter<UnionTimestamp, Object> {
  const _UnionTimestampConverter({this.alwaysUseServerTimestamp = false});

  /// toJson（Firestore への書き込み）時に、常に FieldValue.serverTimestamp を使用するかどうか。
  final bool alwaysUseServerTimestamp;

  @override
  UnionTimestamp fromJson(Object json) {
    final timestamp = json as Timestamp;
    return UnionTimestamp.dateTime(timestamp.toDate());
  }

  @override
  Object toJson(UnionTimestamp unionTimestamp) => alwaysUseServerTimestamp
      ? FieldValue.serverTimestamp()
      : unionTimestamp.map(
          dateTime: (unionDateTime) => Timestamp.fromDate(unionDateTime.dateTime),
          serverTimestamp: (_) => FieldValue.serverTimestamp(),
        );
}

/// freezed の Union Type で定義した
/// Dart の DateTime 型と Firestore の FieldValue.serverTimestamp() を
/// まとめて扱うことができるクラス。
@freezed
class UnionTimestamp with _$UnionTimestamp {
  /// Dart の DateTime 型
  const factory UnionTimestamp.dateTime(DateTime dateTime) = UnionDateTime;

  /// Firestore の FieldValue.serverTimestamp()
  const factory UnionTimestamp.serverTimestamp() = UnionServerTimestamp;

  const UnionTimestamp._();

  /// UnionTimestamp.dateTime の DateTime を返す。
  /// serverTimestamp の場合は null を返す。
  DateTime? get dateTime => mapOrNull(dateTime: (unionDateTime) => unionDateTime.dateTime);
}
