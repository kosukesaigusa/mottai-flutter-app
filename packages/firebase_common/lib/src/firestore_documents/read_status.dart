import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

part 'read_status.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'chatRooms/{chatRoomId}/readStatuses',
  documentName: 'readStatus',
)
class ReadStatus {
  const ReadStatus({
    required this.userId,
    this.lastReadAt = const ServerTimestamp(),
  });

  final String userId;

  @sealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  @UpdateDefault(ServerTimestamp())
  final SealedTimestamp lastReadAt;
}
