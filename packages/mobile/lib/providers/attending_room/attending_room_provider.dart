import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../auth/auth_providers.dart';

/// ユーザーの attendingRoom コレクションを購読する StreamProvider
final attendingRoomsStreamProvider = StreamProvider<List<AttendingRoom>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return MessageRepository.subscribeAttendingRooms(userId: userId);
});
