import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers.dart';
import 'playground_message_state.dart';

const limit = 10;
const scrollValueThreshold = 0.8;

final playgroundMessageStateNotifierProvider = StateNotifierProvider.autoDispose<
    PlaygroundMessageStateNotifierProvider, PlaygroundMessageState>(
  (ref) {
    final userId = ref.watch(userIdProvider).value;
    if (userId == null) {
      throw const SignInRequiredException();
    }
    return PlaygroundMessageStateNotifierProvider()..initialize();
  },
);

/// PlaygroundMessagePage の状態を管理・操作する StateNotifierProvider
class PlaygroundMessageStateNotifierProvider extends StateNotifier<PlaygroundMessageState> {
  PlaygroundMessageStateNotifierProvider() : super(const PlaygroundMessageState());

  late StreamSubscription<List<PlaygroundMessage>> _newMessagesSubscription;
  late ScrollController scrollController;

  @override
  void dispose() {
    _newMessagesSubscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

  /// 初期化処理。
  /// コンストラクタメソッドと一緒にコールする。
  Future<void> initialize() async {
    _initializeScrollController();
    _initializeNewMessagesSubscription();
    await Future.wait<void>([
      loadMore(),
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);
    state = state.copyWith(loading: false);
  }

  /// 読み取り開始時刻以降のメッセージを購読して
  /// 画面に表示する messages に反映させるリスナーを初期化する。
  void _initializeNewMessagesSubscription() {
    _newMessagesSubscription = PlaygroundMessageRepository.subscribePlaygroundMessages(
      queryBuilder: (q) => q
          .orderBy('createdAt', descending: true)
          .where('createdAt', isGreaterThanOrEqualTo: DateTime.now()),
    ).listen((messages) {
      state = state.copyWith(newMessages: messages);
      _updateMessages();
    });
  }

  /// ListView の ScrollController を初期化して、
  /// 過去のメッセージを遡って取得するための Listener を設定する。
  void _initializeScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      final scrollValue = scrollController.offset / scrollController.position.maxScrollExtent;
      if (scrollValue > scrollValueThreshold) {
        await loadMore();
      }
    });
  }

  /// 過去のメッセージを、最後に取得した queryDocumentSnapshot 以降の
  /// limit 件だけ取得する。
  Future<void> loadMore() async {
    if (!state.hasMore) {
      state = state.copyWith(fetching: false);
      return;
    }
    if (state.fetching) {
      return;
    }
    state = state.copyWith(fetching: true);
    var query =
        PlaygroundMessageRepository.playgroundMessagesRef.orderBy('createdAt', descending: true);
    final qds = state.lastVisibleQds;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    final qs = await query.limit(limit).get();
    final messages = qs.docs.map((qds) => qds.data()).toList();
    state = state.copyWith(pastMessages: [...state.pastMessages, ...messages]);
    _updateMessages();
    state = state.copyWith(
      fetching: false,
      lastVisibleQds: qs.docs.isNotEmpty ? qs.docs.last : null,
      hasMore: qs.docs.length >= limit,
    );
  }

  /// 表示するメッセージを更新する
  void _updateMessages() {
    state = state.copyWith(messages: [...state.newMessages, ...state.pastMessages]);
  }
}
