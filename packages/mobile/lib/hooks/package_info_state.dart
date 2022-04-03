import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfoState usePackageInfoState() {
  final objectRef = useRef(const PackageInfoState(fetched: false));
  final packageInfoAsyncSnapshot =
      useFuture<PackageInfo>(useMemoized<Future<PackageInfo>>(PackageInfo.fromPlatform));
  // ignore: join_return_with_assignment
  objectRef.value = PackageInfoState(
    fetched: packageInfoAsyncSnapshot.hasData,
    packageInfo: packageInfoAsyncSnapshot.data,
  );
  return objectRef.value;
}

@immutable
class PackageInfoState {
  const PackageInfoState({
    required this.fetched,
    this.packageInfo,
  });

  final bool fetched;
  final PackageInfo? packageInfo;
}
