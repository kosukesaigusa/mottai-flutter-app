import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../scaffold_messenger_controller.dart';
import '../sample_todos.dart';

final sampleTodosControllerProvider =
    Provider.autoDispose<SampleTodosController>(
  (ref) => SampleTodosController(
    sampleTodoService: ref.watch(sampleTodoServiceProvider),
    appScaffoldMessengerController:
        ref.watch(appScaffoldMessengerControllerProvider),
  ),
);

class SampleTodosController {
  const SampleTodosController({
    required SampleTodoService sampleTodoService,
    required AppScaffoldMessengerController appScaffoldMessengerController,
  })  : _sampleTodoService = sampleTodoService,
        _appScaffoldMessengerController = appScaffoldMessengerController;

  final SampleTodoService _sampleTodoService;

  final AppScaffoldMessengerController _appScaffoldMessengerController;

  /// [SampleTodo] を追加する。
  Future<void> addTodo({
    required String title,
    required String description,
    required DateTime? dueDateTime,
  }) async {
    if (title.isEmpty || description.isEmpty || dueDateTime == null) {
      await _appScaffoldMessengerController.showDialogByBuilder<void>(
        builder: (_) => const AlertDialog(
          title: Text('入力内容の確認'),
          content: Text('入力内容が正しくありません。確認してください。'),
        ),
      );
      return;
    }
    await _sampleTodoService.add(
      title: title,
      description: description,
      dueDateTime: dueDateTime,
    );
    _appScaffoldMessengerController.showSnackBar('Todo を追加しました。');
  }

  /// 指定した [SampleTodo] の `isDone` をトグルする。
  Future<void> toggleCompletionStatus({
    required ReadSampleTodo readSampleTodo,
  }) =>
      _sampleTodoService.updateCompletionStatus(
        sampleTodoId: readSampleTodo.sampleTodoId,
        value: !readSampleTodo.isDone,
      );
}
