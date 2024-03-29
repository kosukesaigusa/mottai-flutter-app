import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'read_status.flutterfire_gen.dart';

// NOTE: ドキュメント ID は userId に一致する。
@FirestoreDocument(
  path: 'chatRooms/{chatRoomId}/readStatuses',
  documentName: 'readStatus',
)
class ReadStatus {
  const ReadStatus({
    this.lastReadAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? lastReadAt;
}
