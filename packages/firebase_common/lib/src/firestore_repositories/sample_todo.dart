import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore_documents/sample_todo.dart';

class SampleTodoRepository {
  final _query = SampleTodoQuery();

  /// [SampleTodo] 一覧を `dueDateTime` の降順で取得する。
  Future<List<ReadSampleTodo>> fetchTodos() => _query.fetchDocuments(
        queryBuilder: (query) => query.orderBy('dueDateTime', descending: true),
      );

  /// [SampleTodo] を作成する。
  Future<DocumentReference<CreateSampleTodo>> createTodo({
    required CreateSampleTodo createSampleTodo,
  }) =>
      _query.create(createSampleTodo: createSampleTodo);

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
