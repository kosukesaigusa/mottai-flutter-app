// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker.dart';

class ReadWorker {
  const ReadWorker({
    required this.workerId,
    required this.path,
    required this.displayName,
    required this.imageUrl,
    required this.introduction,
    required this.isHost,
    required this.createdAt,
    required this.updatedAt,
  });

  final String workerId;

  final String path;

  final String displayName;

  final String imageUrl;

  final String introduction;

  final bool isHost;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadWorker._fromJson(Map<String, dynamic> json) {
    return ReadWorker(
      workerId: json['workerId'] as String,
      path: json['path'] as String,
      displayName: json['displayName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      isHost: json['isHost'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadWorker.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadWorker._fromJson(<String, dynamic>{
      ...data,
      'workerId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateWorker {
  const CreateWorker({
    required this.displayName,
    this.imageUrl = '',
    this.introduction = '',
    required this.isHost,
  });

  final String displayName;
  final String imageUrl;
  final String introduction;
  final bool isHost;

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'imageUrl': imageUrl,
      'introduction': introduction,
      'isHost': isHost,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateWorker {
  const UpdateWorker({
    this.displayName,
    this.imageUrl,
    this.introduction,
    this.isHost,
    this.createdAt,
  });

  final String? displayName;
  final String? imageUrl;
  final String? introduction;
  final bool? isHost;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (introduction != null) 'introduction': introduction,
      if (isHost != null) 'isHost': isHost,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteWorker {}

/// Provides a reference to the workers collection for reading.
final readWorkerCollectionReference =
    FirebaseFirestore.instance.collection('workers').withConverter<ReadWorker>(
          fromFirestore: (ds, _) => ReadWorker.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a worker document for reading.
DocumentReference<ReadWorker> readWorkerDocumentReference({
  required String workerId,
}) =>
    readWorkerCollectionReference.doc(workerId);

/// Provides a reference to the workers collection for creating.
final createWorkerCollectionReference = FirebaseFirestore.instance
    .collection('workers')
    .withConverter<CreateWorker>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a worker document for creating.
DocumentReference<CreateWorker> createWorkerDocumentReference({
  required String workerId,
}) =>
    createWorkerCollectionReference.doc(workerId);

/// Provides a reference to the workers collection for updating.
final updateWorkerCollectionReference = FirebaseFirestore.instance
    .collection('workers')
    .withConverter<UpdateWorker>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a worker document for updating.
DocumentReference<UpdateWorker> updateWorkerDocumentReference({
  required String workerId,
}) =>
    updateWorkerCollectionReference.doc(workerId);

/// Provides a reference to the workers collection for deleting.
final deleteWorkerCollectionReference = FirebaseFirestore.instance
    .collection('workers')
    .withConverter<DeleteWorker>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a worker document for deleting.
DocumentReference<DeleteWorker> deleteWorkerDocumentReference({
  required String workerId,
}) =>
    deleteWorkerCollectionReference.doc(workerId);

/// Manages queries against the workers collection.
class WorkerQuery {
  /// Fetches [ReadWorker] documents.
  Future<List<ReadWorker>> fetchDocuments({
    GetOptions? options,
    Query<ReadWorker>? Function(Query<ReadWorker> query)? queryBuilder,
    int Function(ReadWorker lhs, ReadWorker rhs)? compare,
  }) async {
    Query<ReadWorker> query = readWorkerCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(options);
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Subscribes [Worker] documents.
  Stream<List<ReadWorker>> subscribeDocuments({
    Query<ReadWorker>? Function(Query<ReadWorker> query)? queryBuilder,
    int Function(ReadWorker lhs, ReadWorker rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadWorker> query = readWorkerCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    var streamQs =
        query.snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamQs = streamQs.where((qs) => !qs.metadata.hasPendingWrites);
    }
    return streamQs.map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// Fetches a specific [ReadWorker] document.
  Future<ReadWorker?> fetchDocument({
    required String workerId,
    GetOptions? options,
  }) async {
    final ds = await readWorkerDocumentReference(
      workerId: workerId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Worker] document.
  Stream<ReadWorker?> subscribeDocument({
    required String workerId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readWorkerDocumentReference(
      workerId: workerId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Worker] document.
  Future<DocumentReference<CreateWorker>> add({
    required CreateWorker createWorker,
  }) =>
      createWorkerCollectionReference.add(createWorker);

  /// Sets a [Worker] document.
  Future<void> set({
    required String workerId,
    required CreateWorker createWorker,
    SetOptions? options,
  }) =>
      createWorkerDocumentReference(
        workerId: workerId,
      ).set(createWorker, options);

  /// Updates a specific [Worker] document.
  Future<void> update({
    required String workerId,
    required UpdateWorker updateWorker,
  }) =>
      updateWorkerDocumentReference(
        workerId: workerId,
      ).update(updateWorker.toJson());

  /// Deletes a specific [Worker] document.
  Future<void> delete({
    required String workerId,
  }) =>
      deleteWorkerDocumentReference(
        workerId: workerId,
      ).delete();
}
