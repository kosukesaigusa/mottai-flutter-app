import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../providers/map/map.dart';
import '../utils/extensions/build_context.dart';
import '../utils/extensions/int.dart';
import '../utils/geo.dart';

const double _stackedGreyBackgroundHeight = 200;
const double _stackedGreyBackgroundBorderRadius = 36;
const double _stackedGreyBackgroundPaddingTop = 8;
const double _nearMeCircleSize = 32;
const double _nearMeIconSize = 20;
const double _pageViewHorizontalMargin = 4;
const double _pageViewVerticalMargin = 8;
const double _pageViewHorizontalPadding = 8;
const double _pageViewVerticalPadding = 16;
const double _pageViewBorderRadius = 16;

/// マップページ
class MapPage extends HookConsumerWidget {
  const MapPage({super.key});

  static const path = '/map';
  static const name = 'MapPage2';
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          const GoogleMapWidget(),
          if (kDebugMode)
            const Positioned(
              child: Align(alignment: Alignment.topCenter, child: MapDebugIndicator()),
            ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _stackedGreyBackGround,
            ),
          ),
          const Positioned(
            child: Align(alignment: Alignment.bottomCenter, child: HostLocationPageView()),
          ),
        ],
      ),
    );
  }

  static final Widget _stackedGreyBackGround = Container(
    height: _stackedGreyBackgroundHeight,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_stackedGreyBackgroundBorderRadius),
        topRight: Radius.circular(_stackedGreyBackgroundBorderRadius),
      ),
    ),
  );
}

///
class GoogleMapWidget extends HookConsumerWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      circles: {
        Circle(
          circleId: const CircleId('value'),
          center: ref.watch(centerLatLngProvider),
          // 1000 を乗じて km に換算する
          radius: ref.watch(radiusProvider) * 1000,
          fillColor: Colors.black12,
          strokeWidth: 0,
        ),
      },
      onMapCreated: (googleMapController) =>
          ref.read(googleMapControllerProvider.notifier).update((state) => googleMapController),
      initialCameraPosition: CameraPosition(
        target: ref.watch(centerLatLngProvider),
        zoom: ref.watch(zoomProvider),
      ),
      markers: ref.watch(markersProvider),
      minMaxZoomPreference: const MinMaxZoomPreference(minZoomLevel, maxZoomLevel),
      onCameraIdle: () {
        // マップのドラッグ操作による移動およびズームの変更のときのみ。
        // 検出範囲をリセットする。
        if (ref.read(willResetDetectionRangeProvider)) {
          ref.read(resetDetectionRangeProvider)();
        } else {
          // PageView のスワイプによるカメラ移動ではここが動作する。
          // 次のマップのドラッグ操作・ズーム変更に備えて true に更新する。
          ref.read(willResetDetectionRangeProvider.notifier).update((state) => true);
        }
      },
      onCameraMove: (cameraPosition) =>
          ref.read(cameraPositionProvider.notifier).update((state) => cameraPosition),
    );
  }
}

/// Map 内の検出範囲や検出結果などをデバッグように表示するウィジェット。
class MapDebugIndicator extends HookConsumerWidget {
  const MapDebugIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = ref.watch(centerLatLngProvider);
    final zoom = ref.watch(zoomProvider);
    final radius = ref.watch(radiusProvider);
    final markers = ref.watch(markersProvider);
    final selectedHostLocation = ref.watch(selectedHostLocationProvider);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 48, left: 16, right: 16),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('デバッグウィンドウ', style: context.titleSmall!.copyWith(color: Colors.white)),
          const Gap(8),
          Text(
            '検出範囲は、画面中央を中心とする薄灰色の円の内側です。',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            'Center: (lat, lng) = ('
            '${(center.latitude * 1000).round() / 1000}, '
            '${(center.longitude * 1000).round() / 1000})',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            'Zoom level: ${(zoom * 100).round() / 100}',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            'Radius: ${radius.toInt().withComma} km',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            'Detected  markers: ${markers.length.withComma}',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          Text(
            '選択中: ${selectedHostLocation?.hostLocationId ?? ''}',
            style: context.bodySmall!.copyWith(color: Colors.white),
          ),
          const Gap(8),
        ],
      ),
    );
  }
}

/// マップ上で検出されている HostLocation を表示する部分。
class HostLocationPageView extends HookConsumerWidget {
  const HostLocationPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 32),
          width: _nearMeCircleSize,
          height: _nearMeCircleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.primaryColor,
          ),
          child: GestureDetector(
            onTap: () => ref.read(backToCurrentPositionProvider)(),
            child: const Icon(
              Icons.near_me,
              size: _nearMeIconSize,
              color: Colors.white,
            ),
          ),
        ),
        const Gap(_pageViewVerticalMargin),
        const SizedBox(
          height: _stackedGreyBackgroundHeight -
              _pageViewVerticalMargin * 2 -
              _nearMeCircleSize -
              _stackedGreyBackgroundPaddingTop,
          child: HostLocationsOnMapPageView(),
        ),
        const Gap(_pageViewVerticalMargin),
      ],
    );
  }
}

/// マップ上で検出されている HostLocation の PageView ウィジェット。
class HostLocationsOnMapPageView extends HookConsumerWidget {
  const HostLocationsOnMapPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostLocationsOnMap = ref.watch(hostLocationsOnMapProvider);
    return PageView(
      controller: ref.watch(pageControllerProvider),
      physics: const ClampingScrollPhysics(),
      onPageChanged: (index) => ref.read(onPageChangedProvider)(index),
      children: [
        if (hostLocationsOnMap.isEmpty)
          _wrapper(
            child: Center(child: Text('周辺にデータが見つかりません。', style: context.bodySmall)),
          ),
        for (final hostLocation in hostLocationsOnMap)
          _wrapper(child: HostLocationPageViewItem(hostLocation: hostLocation)),
      ],
    );
  }

  /// PageViewItem を囲む Container ウィジェット。
  static Widget _wrapper({required Widget child}) => Container(
        margin: const EdgeInsets.symmetric(horizontal: _pageViewHorizontalMargin),
        padding: const EdgeInsets.symmetric(
          horizontal: _pageViewHorizontalPadding,
          vertical: _pageViewVerticalPadding,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(_pageViewBorderRadius)),
        ),
        child: child,
      );
}

/// PageView のひとつひとつのウィジェット。
class HostLocationPageViewItem extends HookConsumerWidget {
  const HostLocationPageViewItem({
    super.key,
    required this.hostLocation,
  });

  final HostLocation hostLocation;

  static const double pageViewImageBorderRadius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(pageViewImageBorderRadius),
              child: Image.network(hostLocation.imageURL),
            ),
          ),
        ),
        const Gap(8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hostLocation.hostLocationId,
                style: context.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Gap(4),
              Text(
                hostLocation.description,
                style: context.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color: context.theme.primaryColor,
                  ),
                  Text(
                    hostLocation.address,
                    style: context.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
