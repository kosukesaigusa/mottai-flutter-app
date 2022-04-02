import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

NetworkState useNetworkState() {
  final state = useRef(const NetworkState(fetched: false));
  final connectivityChanged = useStream(useMemoized(() => Connectivity().onConnectivityChanged));
  // ignore: join_return_with_assignment
  state.value =
      NetworkState(fetched: connectivityChanged.hasData, connectivity: connectivityChanged.data);
  return state.value;
}

bool useNetworkConnected() {
  final state = useRef(const NetworkState(fetched: false));
  final connectivityChanged = useStream(useMemoized(() => Connectivity().onConnectivityChanged));
  state.value =
      NetworkState(fetched: connectivityChanged.hasData, connectivity: connectivityChanged.data);
  return state.value.connected;
}

@immutable
class NetworkState {
  const NetworkState({
    required this.fetched,
    ConnectivityResult? connectivity,
  }) : _connectivity = connectivity ?? ConnectivityResult.none;

  final bool fetched;

  final ConnectivityResult _connectivity;
  ConnectivityResult get connectivity => _connectivity;
  bool get connected => connectivity != ConnectivityResult.none;
}
