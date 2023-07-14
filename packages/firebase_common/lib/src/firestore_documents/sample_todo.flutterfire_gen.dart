// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_todo.dart';

class ReadSampleTodo {
  const ReadSampleTodo._({
    required this.sampleTodoId,
    required this.sampleTodoReference,
    required this.title,
    required this.description,
    required this.isDone,
    required this.dueDateTime,
    required this.updatedAt,
  });

  final String sampleTodoId;
  final DocumentReference<ReadSampleTodo> sampleTodoReference;
  final String title;
  final String description;
  final bool isDone;
  final DateTime dueDateTime;
  final SealedTimestamp updatedAt;

  factory ReadSampleTodo._fromJson(Map<String, dynamic> json) {
    return ReadSampleTodo._(
      sampleTodoId: json['sampleTodoId'] as String,
      sampleTodoReference:
          json['sampleTodoReference'] as DocumentReference<ReadSampleTodo>,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
      dueDateTime: (json['dueDateTime'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadSampleTodo.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadSampleTodo._fromJson(<String, dynamic>{
      ...data,
      'sampleTodoId': ds.id,
      'sampleTodoReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadSampleTodo.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadSampleTodo copyWith({
    String? sampleTodoId,
    DocumentReference<ReadSampleTodo>? sampleTodoReference,
    String? title,
    String? description,
    bool? isDone,
    DateTime? dueDateTime,
    SealedTimestamp? updatedAt,
  }) {
    return ReadSampleTodo._(
      sampleTodoId: sampleTodoId ?? this.sampleTodoId,
      sampleTodoReference: sampleTodoReference ?? this.sampleTodoReference,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateSampleTodo {
  const CreateSampleTodo({
    required this.title,
    required this.description,
    this.isDone = false,
    required this.dueDateTime,
    this.updatedAt = const ServerTimestamp(),
  });

  final String title;
  final String description;
  final bool isDone;
  final DateTime dueDateTime;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'dueDateTime': dueDateTime,
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateSampleTodo {
  const UpdateSampleTodo({
    this.title,
    this.description,
    this.isDone,
    this.dueDateTime,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? title;
  final String? description;
  final bool? isDone;
  final DateTime? dueDateTime;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isDone != null) 'isDone': isDone,
      if (dueDateTime != null) 'dueDateTime': dueDateTime,
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to sampleTodos collection to read.
final readSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<ReadSampleTodo>(
      fromFirestore: (ds, _) => ReadSampleTodo.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to sampleTodo document to read.
DocumentReference<ReadSampleTodo> readSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    readSampleTodoCollectionReference.doc(sampleTodoId);

/// A [CollectionReference] to sampleTodos collection to create.
final createSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<CreateSampleTodo>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to sampleTodo document to create.
DocumentReference<CreateSampleTodo> createSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    createSampleTodoCollectionReference.doc(sampleTodoId);

/// A [CollectionReference] to sampleTodos collection to update.
final updateSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<UpdateSampleTodo>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to sampleTodo document to update.
DocumentReference<UpdateSampleTodo> updateSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    updateSampleTodoCollectionReference.doc(sampleTodoId);

/// A [CollectionReference] to sampleTodos collection to delete.
final deleteSampleTodoCollectionReference =
    FirebaseFirestore.instance.collection('sampleTodos');

/// A [DocumentReference] to sampleTodo document to delete.
DocumentReference<Object?> deleteSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    deleteSampleTodoCollectionReference.doc(sampleTodoId);

/// A query manager to execute query against [SampleTodo].
class SampleTodoQuery {
  /// Fetches [ReadSampleTodo] documents.
  Future<List<ReadSampleTodo>> fetchDocuments({
    GetOptions? options,
    Query<ReadSampleTodo>? Function(Query<ReadSampleTodo> query)? queryBuilder,
    int Function(ReadSampleTodo lhs, ReadSampleTodo rhs)? compare,
  }) async {
    Query<ReadSampleTodo> query = readSampleTodoCollectionReference;
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

  /// Subscribes [SampleTodo] documents.
  Stream<List<ReadSampleTodo>> subscribeDocuments({
    Query<ReadSampleTodo>? Function(Query<ReadSampleTodo> query)? queryBuilder,
    int Function(ReadSampleTodo lhs, ReadSampleTodo rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadSampleTodo> query = readSampleTodoCollectionReference;
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

  /// Fetches a specified [ReadSampleTodo] document.
  Future<ReadSampleTodo?> fetchDocument({
    required String sampleTodoId,
    GetOptions? options,
  }) async {
    final ds = await readSampleTodoDocumentReference(
      sampleTodoId: sampleTodoId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [SampleTodo] document.
  Future<Stream<ReadSampleTodo?>> subscribeDocument({
    required String sampleTodoId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readSampleTodoDocumentReference(
      sampleTodoId: sampleTodoId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [SampleTodo] document.
  Future<DocumentReference<CreateSampleTodo>> add({
    required CreateSampleTodo createSampleTodo,
  }) =>
      createSampleTodoCollectionReference.add(createSampleTodo);

  /// Sets a [SampleTodo] document.
  Future<void> set({
    required String sampleTodoId,
    required CreateSampleTodo createSampleTodo,
    SetOptions? options,
  }) =>
      createSampleTodoDocumentReference(
        sampleTodoId: sampleTodoId,
      ).set(createSampleTodo, options);

  /// Updates a specified [SampleTodo] document.
  Future<void> update({
    required String sampleTodoId,
    required UpdateSampleTodo updateSampleTodo,
  }) =>
      updateSampleTodoDocumentReference(
        sampleTodoId: sampleTodoId,
      ).update(updateSampleTodo.toJson());

  /// Deletes a specified [SampleTodo] document.
  Future<void> delete({
    required String sampleTodoId,
  }) =>
      deleteSampleTodoDocumentReference(
        sampleTodoId: sampleTodoId,
      ).delete();
}
