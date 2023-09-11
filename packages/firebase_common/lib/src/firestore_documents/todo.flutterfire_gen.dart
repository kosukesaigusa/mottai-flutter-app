// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo.dart';

class ReadTodo {
  const ReadTodo({
    required this.todoId,
    required this.path,
    required this.title,
    required this.description,
    required this.isDone,
    required this.dueDateTime,
    required this.updatedAt,
  });

  final String todoId;

  final String path;

  final String title;

  final String description;

  final bool isDone;

  final DateTime dueDateTime;

  final DateTime? updatedAt;

  factory ReadTodo._fromJson(Map<String, dynamic> json) {
    return ReadTodo(
      todoId: json['todoId'] as String,
      path: json['path'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
      dueDateTime: (json['dueDateTime'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadTodo.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadTodo._fromJson(<String, dynamic>{
      ...data,
      'todoId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateTodo {
  const CreateTodo({
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

class UpdateTodo {
  const UpdateTodo({
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

class DeleteTodo {}

/// Provides a reference to the sampleTodos collection for reading.
final readTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<ReadTodo>(
      fromFirestore: (ds, _) => ReadTodo.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a todo document for reading.
DocumentReference<ReadTodo> readTodoDocumentReference({
  required String todoId,
}) =>
    readTodoCollectionReference.doc(todoId);

/// Provides a reference to the sampleTodos collection for creating.
final createTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<CreateTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a todo document for creating.
DocumentReference<CreateTodo> createTodoDocumentReference({
  required String todoId,
}) =>
    createTodoCollectionReference.doc(todoId);

/// Provides a reference to the sampleTodos collection for updating.
final updateTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<UpdateTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a todo document for updating.
DocumentReference<UpdateTodo> updateTodoDocumentReference({
  required String todoId,
}) =>
    updateTodoCollectionReference.doc(todoId);

/// Provides a reference to the sampleTodos collection for deleting.
final deleteTodoCollectionReference = FirebaseFirestore.instance
    .collection('sampleTodos')
    .withConverter<DeleteTodo>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a todo document for deleting.
DocumentReference<DeleteTodo> deleteTodoDocumentReference({
  required String todoId,
}) =>
    deleteTodoCollectionReference.doc(todoId);

/// Manages queries against the sampleTodos collection.
class TodoQuery {
  /// Fetches [ReadTodo] documents.
  Future<List<ReadTodo>> fetchDocuments({
    GetOptions? options,
    Query<ReadTodo>? Function(Query<ReadTodo> query)? queryBuilder,
    int Function(ReadTodo lhs, ReadTodo rhs)? compare,
  }) async {
    Query<ReadTodo> query = readTodoCollectionReference;
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

  /// Subscribes [Todo] documents.
  Stream<List<ReadTodo>> subscribeDocuments({
    Query<ReadTodo>? Function(Query<ReadTodo> query)? queryBuilder,
    int Function(ReadTodo lhs, ReadTodo rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadTodo> query = readTodoCollectionReference;
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

  /// Fetches a specific [ReadTodo] document.
  Future<ReadTodo?> fetchDocument({
    required String todoId,
    GetOptions? options,
  }) async {
    final ds = await readTodoDocumentReference(
      todoId: todoId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Todo] document.
  Stream<ReadTodo?> subscribeDocument({
    required String todoId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readTodoDocumentReference(
      todoId: todoId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Todo] document.
  Future<DocumentReference<CreateTodo>> add({
    required CreateTodo createTodo,
  }) =>
      createTodoCollectionReference.add(createTodo);

  /// Sets a [Todo] document.
  Future<void> set({
    required String todoId,
    required CreateTodo createTodo,
    SetOptions? options,
  }) =>
      createTodoDocumentReference(
        todoId: todoId,
      ).set(createTodo, options);

  /// Updates a specific [Todo] document.
  Future<void> update({
    required String todoId,
    required UpdateTodo updateTodo,
  }) =>
      updateTodoDocumentReference(
        todoId: todoId,
      ).update(updateTodo.toJson());

  /// Deletes a specific [Todo] document.
  Future<void> delete({
    required String todoId,
  }) =>
      deleteTodoDocumentReference(
        todoId: todoId,
      ).delete();
}
