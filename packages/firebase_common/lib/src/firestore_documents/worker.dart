import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'worker.flutterfire_gen.dart';

@FirestoreDocument(path: 'workers', documentName: 'worker')
class Worker {
  const Worker({
    required this.displayName,
    required this.imageUrl,
    required this.introduction,
    required this.isHost,
    required this.introduction,
    this.createdAt,
    this.updatedAt,
  });

  @ReadDefault('')
  final String displayName;

  @ReadDefault('')
  @CreateDefault('')
  final String imageUrl;

  @ReadDefault('')
  @CreateDefault('')
  final String introduction;

  @ReadDefault(false)
  final bool isHost;

  @ReadDefault('')
  final String introduction;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
