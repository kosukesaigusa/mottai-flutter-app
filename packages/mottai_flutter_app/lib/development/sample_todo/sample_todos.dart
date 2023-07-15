import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';
import 'ui/sample_todos.dart';

final sampleTodosOrderByStateProvider =
    StateProvider.autoDispose<SampleTodosOrderBy>(
  (ref) => SampleTodosOrderBy.dueDateTimeDesc,
);

final sampleTodosFutureProvider =
    StreamProvider.autoDispose<List<ReadSampleTodo>>((ref) {
  final repository = ref.watch(sampleTodoRepositoryProvider);
  return repository.subscribeTodos(
    descending: ref.watch(sampleTodosOrderByStateProvider) ==
        SampleTodosOrderBy.dueDateTimeAsc,
  );
});

final sampleTodoServiceProvider = Provider.autoDispose<SampleTodoService>(
  (ref) => SampleTodoService(
    sampleTodoRepository: ref.watch(sampleTodoRepositoryProvider),
  ),
);

class SampleTodoService {
  const SampleTodoService({required SampleTodoRepository sampleTodoRepository})
      : _sampleTodoRepository = sampleTodoRepository;

  final SampleTodoRepository _sampleTodoRepository;

  /// [SampleTodo] を追加する。
  Future<void> add({
    required String title,
    required String description,
    required DateTime dueDateTime,
  }) =>
      _sampleTodoRepository.add(
        title: title,
        description: description,
        dueDateTime: dueDateTime,
      );

  /// 指定した [SampleTodo] の `isDone` を更新する。
  Future<void> updateCompletionStatus({
    required String sampleTodoId,
    required bool value,
  }) =>
      _sampleTodoRepository.updateCompletionStatus(
        sampleTodoId: sampleTodoId,
        value: value,
      );
}
