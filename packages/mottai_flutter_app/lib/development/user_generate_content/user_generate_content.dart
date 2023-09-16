import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../firestore_repository.dart';

/// 不適切job報告サービス
final inappropriateReportJobServiceProvider =
    Provider.autoDispose<UserInappropriateReportService>(
  (ref) => UserInappropriateReportService(
    reportRepository: ref.watch(inappropriateReportJobRepositoryProvider),
  ),
);

/// 不適切review報告サービス
final inappropriateReportReviewServiceProvider =
    Provider.autoDispose<UserInappropriateReportService>(
  (ref) => UserInappropriateReportService(
    reportRepository: ref.watch(inappropriateReportReviewRepositoryProvider),
  ),
);

class UserInappropriateReportService {
  const UserInappropriateReportService(
      {required UserInappropriateReportRepository reportRepository})
      : _reportRepository = reportRepository;

  final UserInappropriateReportRepository _reportRepository;

  /// 不適切UGCの情報を作成する。
  Future<void> create({
    required String userId,
    required String targetId,
  }) async {
    await _reportRepository.create(
      userId: userId,
      targetId: targetId,
    );
  }
}

/// jobブロックサービス
final blockJobServiceProvider =
    Provider.autoDispose<UserBlockedDocumentService>(
  (ref) => UserBlockedDocumentService(
    blockRepository: ref.watch(blockedJobRepositoryProvider),
  ),
);

/// reviewブロックサービス
final blockReviewServiceProvider =
    Provider.autoDispose<UserBlockedDocumentService>(
  (ref) => UserBlockedDocumentService(
    blockRepository: ref.watch(blockedReviewRepositoryProvider),
  ),
);

class UserBlockedDocumentService {
  const UserBlockedDocumentService(
      {required UserBlockedDocumentRepository blockRepository})
      : _blockRepository = blockRepository;

  final UserBlockedDocumentRepository _blockRepository;

  /// ブロックの情報を作成する。
  Future<void> create({
    required String userId,
    required String targetId,
  }) async {
    await _blockRepository.create(
      userId: userId,
      targetId: targetId,
    );
  }
}
