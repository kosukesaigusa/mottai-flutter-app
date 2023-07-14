import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../sample_todos.dart';
import 'sample_todos_controller.dart';

class SampleTodosPage extends ConsumerWidget {
  const SampleTodosPage({super.key});

  static const path = '/sampleTodos';
  static const name = 'SampleTodosPage';
  static const location = name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo 一覧')),
      body: ref.watch(sampleTodosFutureProvider).when(
            data: (sampleTodos) => ListView.builder(
              itemCount: sampleTodos.length,
              itemBuilder: (context, index) =>
                  _SampleTodoItem(sampleTodos[index]),
            ),
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) => const _AddTodoBottomSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SampleTodoItem extends ConsumerWidget {
  const _SampleTodoItem(this.readSampleTodo);

  final ReadSampleTodo readSampleTodo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          readSampleTodo.isDone
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank,
        ),
        onPressed: () => ref
            .read(sampleTodosControllerProvider)
            .toggleCompletionStatus(readSampleTodo: readSampleTodo),
      ),
      title: Text(readSampleTodo.title),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      subtitle: Text(readSampleTodo.description),
      trailing: Text(readSampleTodo.dueDateTime.formatDate()),
    );
  }
}

class _AddTodoBottomSheet extends ConsumerStatefulWidget {
  const _AddTodoBottomSheet();

  @override
  ConsumerState<_AddTodoBottomSheet> createState() =>
      _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends ConsumerState<_AddTodoBottomSheet> {
  late final TextEditingController _titleTextEditingController;
  late final TextEditingController _descriptionTextEditingController;
  late final TextEditingController _dueDateTimeTextEditingController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    _titleTextEditingController = TextEditingController();
    _descriptionTextEditingController = TextEditingController();
    _dueDateTimeTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    _dueDateTimeTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.all(16),
      padding: EdgeInsets.only(
        top: 32,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Todo の追加',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(16),
          TextField(
            controller: _titleTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'タイトル',
            ),
          ),
          const Gap(16),
          TextField(
            controller: _descriptionTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '説明',
            ),
          ),
          const Gap(16),
          TextField(
            controller: _dueDateTimeTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '締め切り日',
            ),
            readOnly: true,
            onTap: () async {
              final now = DateTime.now();
              final nextYear = DateTime(now.year + 1, now.month, now.day);
              final date = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: nextYear,
              );
              if (date == null) {
                return;
              }
              _selectedDateTime = date;
              _dueDateTimeTextEditingController.text = date.formatDate();
              setState(() {});
            },
          ),
          const Gap(32),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref.read(sampleTodosControllerProvider).addTodo(
                      title: _titleTextEditingController.text,
                      description: _descriptionTextEditingController.text,
                      dueDateTime: _selectedDateTime,
                    );
                navigator.pop();
              },
              child: const Text('Todo を追加する'),
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }
}
