import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../todos.dart';

final todosControllerProvider = Provider.autoDispose<TodosController>(
  (ref) => TodosController(todoService: ref.watch(todoServiceProvider)),
);

class TodosController {
  const TodosController({
    required TodoService todoService,
  }) : _todoService = todoService;

  final TodoService _todoService;

  /// [Todo] を追加する。
  Future<void> addTodo({
    required BuildContext context,
    required String title,
    required String description,
    required DateTime? dueDateTime,
  }) async {
    if (title.isEmpty || description.isEmpty || dueDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('入力内容が正しくありません。確認してください。'),
        ),
      );
      return;
    }
    await _todoService.add(
      title: title,
      description: description,
      dueDateTime: dueDateTime,
    );
  }

  /// 指定した [Todo] の `isDone` をトグルする。
  Future<void> toggleCompletionStatus({
    required String todoId,
    required bool isDone,
  }) =>
      _todoService.updateCompletionStatus(
        todoId: todoId,
        value: isDone,
      );
}
