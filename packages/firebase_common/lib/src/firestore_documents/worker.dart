import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'worker.flutterfire_gen.dart';

@FirestoreDocument(path: 'workers', documentName: 'worker')
class Worker {
  const Worker({
    required this.displayName,
    required this.imageUrl,
    required this.isHost,
    this.createdAt,
    this.updatedAt,
  });

  @ReadDefault('')
  final String displayName;

  @ReadDefault('')
  @CreateDefault('')
  final String imageUrl;

  @ReadDefault(false)
  final bool isHost;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
