import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO: AsyncNotifier で書き換える
/// Firestore のパジネーションを行うための [StateNotifier].
class FirestorePaginationStateNotifier<T>
    extends StateNotifier<AsyncValue<List<T>>> {
  FirestorePaginationStateNotifier({
    required this.fetch,
    required this.idFromObject,
    int initialPerPage = 10,
  }) : super(AsyncValue<List<T>>.data(const [])) {
    _initialize(perPage: initialPerPage);
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

  /// 取得処理中かどうか。
  bool get isFetching => _isFetching;

  /// 次のページがあるかどうか。
  bool get hasNext => _hasNext;

  /// 初期化処理。
  Future<List<T>> _initialize({required int perPage}) async {
    state = AsyncValue<List<T>>.loading();
    _isFetching = true;
    try {
      final items = await fetch(perPage, null);
      state = AsyncValue.data(items);
      _hasNext = items.isNotEmpty;
      if (items.isNotEmpty) {
        _lastFetchedId = idFromObject(items.last);
      }
    } on Exception catch (e, s) {
      state = AsyncValue<List<T>>.error(e, s);
    } finally {
      _isFetching = false;
    }
    return state.valueOrNull ?? [];
  }

  /// 次のページを取得する。
  Future<void> fetchNext({required int perPage}) async {
    final items = state;
    if (_isFetching || items.isRefreshing || !items.hasValue || !_hasNext) {
      return;
    }
    _isFetching = true;
    try {
      final items = await fetch(perPage, _lastFetchedId);
      final newItems = [...state.valueOrNull ?? <T>[], ...items];
      state = AsyncValue.data(newItems);
      _hasNext = items.isNotEmpty;
      if (items.isNotEmpty) {
        _lastFetchedId = idFromObject(items.last);
      }
    } on Exception catch (e, stackTrace) {
      state = AsyncValue<List<T>>.error(e, stackTrace);
      return;
    } finally {
      _isFetching = false;
    }
  }
}
