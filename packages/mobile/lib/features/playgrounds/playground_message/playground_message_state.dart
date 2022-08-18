import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mottai_flutter_app_models/models.dart';

part 'playground_message_state.freezed.dart';

@freezed
class PlaygroundMessageState with _$PlaygroundMessageState {
  const factory PlaygroundMessageState({
    @Default(true) bool loading,
    @Default(<PlaygroundMessage>[]) List<PlaygroundMessage> messages,
    @Default(<PlaygroundMessage>[]) List<PlaygroundMessage> newMessages,
    @Default(<PlaygroundMessage>[]) List<PlaygroundMessage> pastMessages,
    @Default(false) bool fetching,
    @Default(true) bool hasMore,
    QueryDocumentSnapshot<PlaygroundMessage>? lastVisibleQds,
  }) = _PlaygroundMessageState;
}
