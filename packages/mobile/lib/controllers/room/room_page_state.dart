import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_page_state.freezed.dart';

@freezed
class RoomPageState with _$RoomPageState {
  const factory RoomPageState({
    @Default(true) bool loading,
    @Default(false) bool sending,
  }) = _RoomPageState;
}
