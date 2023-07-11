import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'worker.flutterfire_gen.dart';

@FirestoreDocument(path: 'workers', documentName: 'worker')
class Worker {
  Worker({
    required this.displayName,
    this.imageUrl,
  });

  final String displayName;

  @ReadDefault('')
  final String? imageUrl;
}
