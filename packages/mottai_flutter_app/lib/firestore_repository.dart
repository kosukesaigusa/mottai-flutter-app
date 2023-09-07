import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatMessageRepositoryProvider =
    Provider.autoDispose<ChatMessageRepository>((_) => ChatMessageRepository());

final chatRoomRepositoryProvider =
    Provider.autoDispose<ChatRoomRepository>((_) => ChatRoomRepository());

final forceUpdateConfigRepositoryProvider =
    Provider.autoDispose<ForceUpdateConfigRepository>(
  (_) => ForceUpdateConfigRepository(),
);

final hostLocationRepositoryProvider =
    Provider.autoDispose<HostLocationRepository>(
  (_) => HostLocationRepository(),
);

final hostRepositoryProvider =
    Provider.autoDispose<HostRepository>((_) => HostRepository());

final inReviewConfigRepositoryProvider =
    Provider.autoDispose<InReviewConfigRepository>(
  (_) => InReviewConfigRepository(),
);

final jobRepositoryProvider =
    Provider.autoDispose<JobRepository>((_) => JobRepository());

final readStatusRepositoryProvider =
    Provider.autoDispose<ReadStatusRepository>((_) => ReadStatusRepository());

final sampleTodoRepositoryProvider =
    Provider.autoDispose<SampleTodoRepository>((_) => SampleTodoRepository());

final userFcmTokenRepositoryProvider =
    Provider.autoDispose<UserFcmTokenRepository>(
  (_) => UserFcmTokenRepository(),
);

final userSocialLoginRepositoryProvider =
    Provider.autoDispose<UserSocialLoginRepository>(
  (_) => UserSocialLoginRepository(),
);

final workerRepositoryProvider =
    Provider.autoDispose<WorkerRepository>((_) => WorkerRepository());
