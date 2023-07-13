import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/sample_todo.dart';

class SampleTodoRepository {
  final _query = SampleTodoQuery();

  /// [SampleTodo] 一覧を `dueDateTime` の降順で購読する。
  Stream<List<ReadSampleTodo>> subscribeTodos() => _query.subscribeDocuments(
        queryBuilder: (query) => query.orderBy('dueDateTime', descending: true),
      );

  /// [SampleTodo] を作成する。
  Future<DocumentReference<CreateSampleTodo>> createTodo({
    required String title,
    required String description,
    required DateTime dueDateTime,
  }) =>
      _query.create(
        createSampleTodo: CreateSampleTodo(
          title: title,
          description: description,
          dueDateTime: dueDateTime,
        ),
      );

  /// 指定した [SampleTodo] を完了 or 未完了を更新する。
  Future<void> updateCompletionStatus({
    required String sampleTodoId,
    required bool value,
  }) =>
      _query.update(
        sampleTodoId: sampleTodoId,
        updateSampleTodo: UpdateSampleTodo(isDone: value),
      );
}
