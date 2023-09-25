import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mottai_flutter_app/development/sample_todo/ui/todos.dart';
import 'package:mottai_flutter_app/firestore_repository.dart';

import 'todos_test.mocks.dart';

class _TodosPage extends StatelessWidget {
  const _TodosPage();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodosPage(),
    );
  }
}

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

  testWidgets('TodosPage test', (tester) async {
    when(mockTodoRepository.subscribeTodos(descending: true))
        .thenAnswer((_) async* {
      yield descTodos;
    });
    when(mockTodoRepository.subscribeTodos(descending: false))
        .thenAnswer((_) async* {
      yield ascTodos;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todoRepositoryProvider.overrideWithValue(mockTodoRepository),
        ],
        child: const _TodosPage(),
      ),
    );

    // 初期表示の確認
    expect(find.text('Todo 一覧'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Todo 一覧の結果が戻るのを待つ
    await tester.pump();

    // ローディングが完了しており、ListTile が 2 つ表示されていることを確認する
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListTile), findsNWidgets(2));

    // ListTile の Finder を取得する
    final listTileFinder = find.byType(ListTile);

    // 見つかった ListTile ウィジェットをリストにする
    final descListTiles = tester
        .widgetList(listTileFinder)
        .map((widget) => widget as ListTile)
        .toList();

    // 現在は締め切り日時の降順であることを確認する
    expect(find.text(TodosOrderBy.dueDateTimeDesc.label), findsOneWidget);

    // ListTile の数と各 ListTile の title が正しいことを確認する
    expect(descListTiles.length, 2);
    expect((descListTiles[0].title! as Text).data, 'Test Todo 2');
    expect((descListTiles[1].title! as Text).data, 'Test Todo 1');

    // 並び順を操作する DropdownButton をタップする
    await tester.tap(find.byType(DropdownButton<TodosOrderBy>));
    await tester.pump();

    // 並び順を締め切り昇順に変更する
    final dropdownItem = find.text(TodosOrderBy.dueDateTimeAsc.label).last;
    await tester.tap(dropdownItem);
    await tester.pump();

    // ローディング中であることを確認する
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Todo 一覧の結果が戻るのを待つ
    await tester.pump();

    // ローディングが完了しており、ListTile が 2 つ表示されていることを確認する
    expect(find.byType(ListTile), findsNWidgets(2));

    // 見つかった ListTile ウィジェットをリストにする
    final ascListTiles = tester
        .widgetList(listTileFinder)
        .map((widget) => widget as ListTile)
        .toList();

    // 現在は締め切り日時の昇順であることを確認する
    expect(find.text(TodosOrderBy.dueDateTimeAsc.label), findsOneWidget);

    // ListTile の数と各 ListTile の title が正しいことを確認する
    expect(ascListTiles.length, 2);
    expect((ascListTiles[0].title! as Text).data, 'Test Todo 1');
    expect((ascListTiles[1].title! as Text).data, 'Test Todo 2');
  });
}
