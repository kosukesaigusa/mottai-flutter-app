import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Firestore のパジネーションを行うための [StateNotifier].
class FirestorePaginationStateNotifier<T>
    extends StateNotifier<AsyncValue<List<T>>> {
  FirestorePaginationStateNotifier({
    required this.fetch,
    required this.idFromObject,
  }) : super(AsyncValue<List<T>>.data(const [])) {
    _initialize();
  }

  /// データを取得する関数。
  final Future<List<T>> Function(int perPage, String? lastFetchedId) fetch;

  /// データから ID を取得する関数。
  final String Function(T obj) idFromObject;

  /// 最後に取得したデータの ID.
  String? _lastFetchedId;

  /// 取得処理中かどうか。
  bool _isFetching = false;

  /// 次のページがあるかどうか。
  bool _hasNext = true;

  /// リクエスト一回あたりの取得件数のデフォルト値。
  static const _defaultPerPage = 10;

  /// 取得処理中かどうか。
  bool get isFetching => _isFetching;

  /// 次のページがあるかどうか。
  bool get hasNext => _hasNext;

  /// 初期化処理。
  Future<List<T>> _initialize({int perPage = _defaultPerPage}) async {
    state = AsyncValue<List<T>>.loading();
    _isFetching = true;
    try {
      final items = await fetch(perPage, null);
      _hasNext = items.isNotEmpty;
      state = AsyncValue<List<T>>.data(items);
    } on Exception catch (e, s) {
      state = AsyncValue<List<T>>.error(e, s);
    } finally {
      _isFetching = false;
    }
    return state.valueOrNull ?? [];
  }

  /// 次のページを取得する。
  Future<void> fetchNext({int perPage = _defaultPerPage}) async {
    final items = state;
    if (_isFetching || items.isRefreshing || !items.hasValue || !_hasNext) {
      return;
    }
    _isFetching = true;
    try {
      final result = await fetch(perPage, _lastFetchedId);
      final newItems = [...state.valueOrNull ?? <T>[], ...result];
      state = AsyncValue.data(newItems);
      _hasNext = result.isNotEmpty;
      _lastFetchedId = idFromObject(result.last);
    } on Exception catch (e, stackTrace) {
      state = AsyncValue<List<T>>.error(e, stackTrace);
      return;
    } finally {
      _isFetching = false;
    }
  }

  /// リフレッシュする。
  Future<void> refresh({int perPage = _defaultPerPage}) async {
    _isFetching = true;
    _lastFetchedId = null;
    try {
      final items = await fetch(perPage, null);
      _hasNext = items.isNotEmpty;
      state = AsyncValue<List<T>>.data(items);
    } on Exception catch (e, s) {
      state = AsyncValue<List<T>>.error(e, s);
    } finally {
      _isFetching = false;
    }
  }
}
