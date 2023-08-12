// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_todo.dart';

class ReadSampleTodo {
  const ReadSampleTodo({
    required this.sampleTodoId,
    required this.path,
    required this.title,
    required this.description,
    required this.isDone,
    required this.dueDateTime,
    required this.updatedAt,
  });

  final String sampleTodoId;

  final String path;

  final String title;

  final String description;

  final bool isDone;

  final DateTime dueDateTime;

  final DateTime? updatedAt;

  factory ReadSampleTodo._fromJson(Map<String, dynamic> json) {
    return ReadSampleTodo(
      sampleTodoId: json['sampleTodoId'] as String,
      path: json['path'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
      dueDateTime: (json['dueDateTime'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadSampleTodo.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadSampleTodo._fromJson(<String, dynamic>{
      ...data,
      'sampleTodoId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateSampleTodo {
  const CreateSampleTodo({
    required this.title,
    required this.description,
    required this.isDone,
    required this.dueDateTime,
  });

  final String title;
  final String description;
  final bool isDone;
  final DateTime dueDateTime;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'dueDateTime': dueDateTime,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateSampleTodo {
  const UpdateSampleTodo({
    this.title,
    this.description,
    this.isDone,
    this.dueDateTime,
  });

  final String? title;
  final String? description;
  final bool? isDone;
  final DateTime? dueDateTime;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isDone != null) 'isDone': isDone,
      if (dueDateTime != null) 'dueDateTime': dueDateTime,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteSampleTodo {}

/// Provides a reference to the sampleTodos collection for reading.
final readSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<ReadSampleTodo>(
      fromFirestore: (ds, _) => ReadSampleTodo.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a sampleTodo document for reading.
DocumentReference<ReadSampleTodo> readSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    readSampleTodoCollectionReference.doc(sampleTodoId);

/// Provides a reference to the sampleTodos collection for creating.
final createSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<CreateSampleTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a sampleTodo document for creating.
DocumentReference<CreateSampleTodo> createSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    createSampleTodoCollectionReference.doc(sampleTodoId);

/// Provides a reference to the sampleTodos collection for updating.
final updateSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<UpdateSampleTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a sampleTodo document for updating.
DocumentReference<UpdateSampleTodo> updateSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    updateSampleTodoCollectionReference.doc(sampleTodoId);

/// Provides a reference to the sampleTodos collection for deleting.
final deleteSampleTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<DeleteSampleTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a sampleTodo document for deleting.
DocumentReference<DeleteSampleTodo> deleteSampleTodoDocumentReference({
  required String sampleTodoId,
}) =>
    deleteSampleTodoCollectionReference.doc(sampleTodoId);

/// Manages queries against the sampleTodos collection.
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

  /// Fetches a specific [ReadSampleTodo] document.
  Future<ReadSampleTodo?> fetchDocument({
    required String sampleTodoId,
    GetOptions? options,
  }) async {
    final ds = await readSampleTodoDocumentReference(
      sampleTodoId: sampleTodoId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [SampleTodo] document.
  Stream<ReadSampleTodo?> subscribeDocument({
    required String sampleTodoId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
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

  /// Updates a specific [SampleTodo] document.
  Future<void> update({
    required String sampleTodoId,
    required UpdateSampleTodo updateSampleTodo,
  }) =>
      updateSampleTodoDocumentReference(
        sampleTodoId: sampleTodoId,
      ).update(updateSampleTodo.toJson());

  /// Deletes a specific [SampleTodo] document.
  Future<void> delete({
    required String sampleTodoId,
  }) =>
      deleteSampleTodoDocumentReference(
        sampleTodoId: sampleTodoId,
      ).delete();
}
