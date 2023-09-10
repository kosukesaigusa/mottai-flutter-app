import 'package:firebase_common/firebase_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mottai_flutter_app/development/sample_todo/todos.dart';
import 'package:mottai_flutter_app/development/sample_todo/ui/todos.dart';
import 'package:mottai_flutter_app/firestore_repository.dart';

import 'todos_test.mocks.dart';

final testTodo1 = ReadTodo(
  todoId: '1',
  path: '/path/to/todo/1',
  title: 'Test Todo 1',
  description: 'Description 1',
  isDone: false,
  dueDateTime: DateTime(2023),
  updatedAt: DateTime(2023),
);

final testTodo2 = ReadTodo(
  todoId: '2',
  path: '/path/to/todo/2',
  title: 'Test Todo 2',
  description: 'Description 2',
  isDone: true,
  dueDateTime: DateTime(2023, 2),
  updatedAt: DateTime(2023, 2),
);

@GenerateNiceMocks([MockSpec<TodoRepository>()])
void main() {
  final mockTodoRepository = MockTodoRepository();
  final descTodos = [testTodo2, testTodo1];
  final ascTodos = [testTodo1, testTodo2];

  test('todosStreamProvider', () async {
    when(mockTodoRepository.subscribeTodos(descending: true))
        .thenAnswer((_) async* {
      yield descTodos;
    });
    when(mockTodoRepository.subscribeTodos(descending: false))
        .thenAnswer((_) async* {
      yield ascTodos;
    });

    final container = ProviderContainer(
      overrides: [todoRepositoryProvider.overrideWithValue(mockTodoRepository)],
    );
    addTearDown(container.dispose);

    container.listen(
      todosStreamProvider,
      (previous, next) {},
      fireImmediately: true,
    );

    // 並び替え順の初期状態を確認する
    expect(
      container.read(todosOrderByStateProvider),
      TodosOrderBy.dueDateTimeDesc,
    );

    // 最初はローディング中である
    expect(
      container.read(todosStreamProvider),
      const AsyncValue<List<ReadTodo>>.loading(),
    );

    // Todo 一覧の結果が戻るのを待つ
    await container.read(todosStreamProvider.future);

    // 締め切り日時の降順の一覧が返ってきている
    expect(container.read(todosStreamProvider).value, descTodos);

    // 並び替え順を変更する
    container.read(todosOrderByStateProvider.notifier).state =
        TodosOrderBy.dueDateTimeAsc;

    // 並び替え順が変更されたか確認する
    expect(
      container.read(todosOrderByStateProvider.notifier).state,
      TodosOrderBy.dueDateTimeAsc,
    );

    // Todo 一覧の結果が新たに戻るのを待つ
    await container.read(todosStreamProvider.future);

    // 締め切り日時の昇順の一覧が返ってきている
    expect(container.read(todosStreamProvider).value, ascTodos);
  });
}
