import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import 'ui/todos.dart';

final todosOrderByStateProvider = StateProvider.autoDispose<TodosOrderBy>(
  (ref) => TodosOrderBy.dueDateTimeDesc,
);

final todosStreamProvider = StreamProvider.autoDispose<List<ReadTodo>>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.subscribeTodos(
    descending:
        ref.watch(todosOrderByStateProvider) == TodosOrderBy.dueDateTimeDesc,
  );
});

final todoServiceProvider = Provider.autoDispose<TodoService>(
  (ref) => TodoService(todoRepository: ref.watch(todoRepositoryProvider)),
);

class TodoService {
  const TodoService({required TodoRepository todoRepository})
      : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;

  /// [Todo] を追加する。
  Future<void> add({
    required String title,
    required String description,
    required DateTime dueDateTime,
  }) =>
      _todoRepository.add(
        title: title,
        description: description,
        dueDateTime: dueDateTime,
      );

  /// 指定した [Todo] の `isDone` を更新する。
  Future<void> updateCompletionStatus({
    required String todoId,
    required bool value,
  }) =>
      _todoRepository.updateCompletionStatus(
        todoId: todoId,
        value: value,
      );
}
