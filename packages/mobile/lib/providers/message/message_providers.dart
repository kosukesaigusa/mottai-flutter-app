import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../providers.dart';

/// 指定した roomId の messages サブコレクションを購読する StreamProvider
final messagesStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
  final userId = ref.watch(userIdProvider).value;
  if (userId == null) {
    throw const SignInRequiredException();
  }
  return MessageRepository.subscribeMessages(
    roomId: roomId,
    queryBuilder: (q) => q.orderBy('createdAt', descending: true),
  );
});

// /// 指定した roomId の messages サブコレクションの messages の
// /// 現在時刻以降のドキュメントを購読する StreamProvider
// final newMessagesStreamProvider =
//     StreamProvider.autoDispose.family<List<Message>, String>((ref, roomId) {
//   final userId = ref.watch(userIdProvider).value;
//   if (userId == null) {
//     throw const SignInRequiredException();
//   }
//   final now = DateTime.now();
//   print(now);
//   return MessageRepository.subscribeMessages(
//       roomId: roomId,
//       queryBuilder: (q) =>
//           q.where('createdAt', isGreaterThanOrEqualTo: now).orderBy('createdAt', descending: true));
// });

// /// 指定した roomId の messages サブコレクションの messages の
// /// 最新 10 件のドキュメントを取得する FutureProvider
// final pastMessagesFutureProvider = FutureProvider.autoDispose
//     .family<List<Message>, QueryDocumentSnapshot<Message>?>((ref, qds) async {
//   final userId = ref.watch(userIdProvider).value;
//   if (userId == null) {
//     throw const SignInRequiredException();
//   }
//   const roomId = '4f077690-7161-4fb2-b2b3-470fa6541f86';
//   print('🔥 読み取り処理: $qds');
//   final result = await MessageRepository.fetchMessagesWithLastVisibleQds(
//     roomId: roomId,
//     queryBuilder: (q) => qds == null
//         ? q.orderBy('createdAt', descending: true).limit(10)
//         : q.orderBy('createdAt', descending: true).startAfterDocument(qds).limit(10),
//   );
//   final messages = ref.read(roomPageController(roomId).notifier).updateLastVisibleQds(
//         messages: result.data,
//         qds: result.lastVisibleQds,
//       );
//   return messages;
// });

// ///
// final messagesProvider =
//     Provider.autoDispose.family<AsyncValue<List<Message>>, String>((ref, roomId) {
//   final newMessages = ref.watch(newMessagesStreamProvider(roomId)).whenData((messages) => messages);
//   // final messages = ref.watch(messagesFutureProvider(roomId)).whenData((messages) => messages);
//   return AsyncData<List<Message>>([
//     ...newMessages.value ?? <Message>[],
//     // ...messages.value ?? <Message>[],
//   ]);
// });

// final lastVisibleMessageQdsProvider =
//     StateProvider.autoDispose<QueryDocumentSnapshot<Message>?>((ref) => null);
