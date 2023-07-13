import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_json_converters/flutterfire_json_converters.dart';

part 'sample_todo.flutterfire_gen.dart';

@FirestoreDocument(path: 'sampleTodos', documentName: 'sampleTodo')
class SampleTodo {
  const SampleTodo({
    required this.title,
    required this.description,
    this.isDone = false,
    required this.dueDateTime,
    this.updatedAt = const ServerTimestamp(),
  });

  @ReadDefault('')
  final String title;

  @ReadDefault('')
  final String description;

  final bool isDone;

  final DateTime dueDateTime;

  // TODO: やや冗長になってしまっているのは、flutterfire_gen と
  // flutterfire_json_converters の作りのため。それらのパッケージが更新されたら
  // この実装も変更する。
  @alwaysUseServerTimestampSealedTimestampConverter
  @CreateDefault(ServerTimestamp())
  @UpdateDefault(ServerTimestamp())
  final SealedTimestamp updatedAt;
}
