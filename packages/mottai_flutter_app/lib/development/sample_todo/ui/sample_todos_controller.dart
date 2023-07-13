import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../sample_todos.dart';

final sampleTodosControllerProvider =
    Provider.autoDispose<SampleTodosController>(
  (ref) => SampleTodosController(
    sampleTodoService: ref.watch(sampleTodoServiceProvider),
  ),
);

class SampleTodosController {
  const SampleTodosController({
    required SampleTodoService sampleTodoService,
  }) : _sampleTodoService = sampleTodoService;

  final SampleTodoService _sampleTodoService;

  /// [SampleTodo] を追加する。
  Future<void> addTodo({
    required String title,
    required String description,
    required DateTime? dueDateTime,
  }) async {
    if (title.isEmpty || description.isEmpty || dueDateTime == null) {
      return;
    }
    return _sampleTodoService.add(
      title: title,
      description: description,
      dueDateTime: dueDateTime,
    );
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
