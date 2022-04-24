import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_task_result.freezed.dart';

@freezed
class FirebaseTaskResult<T> with _$FirebaseTaskResult<T> {
  /// Firebase の読み書き処理に成功
  const factory FirebaseTaskResult.success({
    required T contents,
    String? message,
    @Default(true) bool success,
  }) = Success<T>;

  /// Firebase の読み書き処理に失敗
  const factory FirebaseTaskResult.failure({
    required String message,
    String? code,
  }) = Failure<T>;

  /// その他のエラー
  const factory FirebaseTaskResult.error(Exception e) = Error<T>;
}
