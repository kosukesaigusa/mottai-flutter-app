import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ks_flutter_commons/ks_flutter_commons.dart';
import 'package:mottai_flutter_app_models/models.dart';

import '../../providers/map/map_page_controller.dart';
import '../../theme/theme.dart';
import '../../utils/geo.dart';
import '../../widgets/loading/loading.dart';

const double stackedGreyBackgroundHeight = 200;
const double stackedGreyBackgroundBorderRadius = 36;
const double stackedGreyBackgroundPaddingTop = 8;
const double pageViewHeight = 148;
const double pageViewHorizontalMargin = 4;
const double pageViewVerticalMargin = 8;
const double pageViewHorizontalPadding = 8;
const double pageViewVerticalPadding = 16;
const double pageViewBorderRadius = 16;
const double pageViewImageBorderRadius = 16;
const double nearMeCircleSize = 32;
const double nearMeIconSize = 20;

class MapPage extends StatefulHookConsumerWidget {
  const MapPage({Key? key}) : super(key: key);

  static const path = '/map/';
  static const name = 'MapPage';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapPageStateNotifierProvider);
    final controller = ref.read(mapPageStateNotifierProvider.notifier);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // TODO: ライトモード・ダークモードの切り替えに対応する。
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: state.ready
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    circles: {
                      Circle(
                        circleId: const CircleId('value'),
                        center: state.center,
                        radius: state.debugRadius.toDouble() * 1000,
                        fillColor: Colors.black12,
                        strokeWidth: 0,
                      ),
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(minZoomLevel, maxZoomLevel),
                    onMapCreated: controller.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: state.center,
                      zoom: state.debugZoomLevel,
                    ),
                    markers: Set<Marker>.of(state.markers.values),
                    onCameraIdle: () {
                      // マップのドラッグ操作による移動およびズームの変更のときのみ。
                      // 検出範囲をリセットする。
                      if (state.resetDetection) {
                        final zoom = controller.cameraPosition.zoom;
                        controller.updateDetectionRange(
                          latLng: controller.cameraPosition.target,
                          radius: getRadiusFromZoom(zoom),
                          zoomLevel: zoom,
                        );
                      } else {
                        // PageView のスワイプによるカメラ移動ではここが動作する。
                        // 次のマップのドラッグ操作・ズーム変更に備えて true に更新する。
                        controller.enableResetDetection();
                      }
                    },
                    onCameraMove: controller.onCameraMove,
                  ),
                  _buildStackedTopIndicator,
                  _buildStackedGreyBackGround,
                  _buildStackedPageViewWidget,
                ],
              )
            : const PrimarySpinkitCircle(),
      ),
    );
  }

  /// Stack で重ねているデバッグ用のズームレベル、半径のインジケータ
  Widget get _buildStackedTopIndicator {
    final state = ref.watch(mapPageStateNotifierProvider);
    final controller = ref.read(mapPageStateNotifierProvider.notifier);
    return Positioned(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 48, left: 16, right: 16),
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('デバッグウィンドウ', style: whiteBold12),
              const Gap(8),
              const Text(
                '検出範囲は、画面中央を中心とする薄灰色の円の内側です。',
                style: white12,
              ),
              Text(
                'Center: (lat, lng) = ('
                '${(state.center.latitude * 1000).round() / 1000}, '
                '${(state.center.longitude * 1000).round() / 1000})',
                style: white12,
              ),
              Text(
                'Zoom level: ${(state.debugZoomLevel * 100).round() / 100}',
                style: white12,
              ),
              Text(
                'Radius: ${addComma(state.debugRadius)} km',
                style: white12,
              ),
              Text(
                '検出件数：${addComma(state.markers.length)} 件',
                style: white12,
              ),
              // Text(
              //   '選択中: ${selectedHostLocation?.hostLocationId ?? ''}',
              //   style: white12,
              // ),
              const Gap(8),
              Slider(
                min: minZoomLevel,
                max: maxZoomLevel,
                divisions: (maxZoomLevel - minZoomLevel).toInt(),
                value: state.debugZoomLevel,
                onChanged: (value) {
                  final latLng = controller.cameraPosition.target;
                  final zoom = value;
                  controller.enableResetDetection();
                  controller.updateCameraPosition(latLng: latLng, zoom: zoom);
                  controller.updateDetectionRange(
                    latLng: latLng,
                    radius: getRadiusFromZoom(zoom),
                    zoomLevel: zoom,
                  );
                },
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }

  /// Stack で重ねている画面下部のグレー背景部分
  Widget get _buildStackedGreyBackGround => Positioned(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: stackedGreyBackgroundHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(stackedGreyBackgroundBorderRadius),
                topRight: Radius.circular(stackedGreyBackgroundBorderRadius),
              ),
            ),
          ),
        ),
      );

  /// Stack で重ねている PageView と near_me アイコン部分
  Widget get _buildStackedPageViewWidget {
    final state = ref.watch(mapPageStateNotifierProvider);
    final controller = ref.read(mapPageStateNotifierProvider.notifier);
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 32),
              width: nearMeCircleSize,
              height: nearMeCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: GestureDetector(
                onTap: controller.backToOriginalPosition,
                child: const Icon(
                  Icons.near_me,
                  size: nearMeIconSize,
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(pageViewVerticalMargin),
            SizedBox(
              height: stackedGreyBackgroundHeight -
                  pageViewVerticalMargin * 2 -
                  nearMeCircleSize -
                  stackedGreyBackgroundPaddingTop,
              child: PageView(
                controller: controller.pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: controller.onPageChanged,
                children: [
                  if (state.hostLocationsOnMap.isEmpty) _buildEmptyPageItem,
                  for (final hostLocation in state.hostLocationsOnMap) _buildPageItem(hostLocation),
                ],
              ),
            ),
            const Gap(pageViewVerticalMargin),
          ],
        ),
      ),
    );
  }

  /// PageView のコンテナ
  Widget _buildPageViewContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: pageViewHorizontalMargin),
      padding: const EdgeInsets.symmetric(
        horizontal: pageViewHorizontalPadding,
        vertical: pageViewVerticalPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(pageViewBorderRadius)),
      ),
      child: child,
    );
  }

  /// PageView のアイテム
  Widget _buildPageItem(HostLocation hostLocation) {
    return _buildPageViewContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(pageViewImageBorderRadius),
                child: Image.network(
                  'https://www.npo-mottai.org/image/news/2021-10-05-activity-report/image-6.jpg',
                ),
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
                  style: bold14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const Gap(4),
                Text(
                  '神奈川県小田原市でみかんを育てています！'
                  'みかん収穫のお手伝いをしてくださる方募集中です🍊'
                  'ぜひお気軽にマッチングリクエストお願いします！',
                  style: grey12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '神奈川県小田原市247番3',
                      style: grey12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 検出範囲に Marker が存在しない場合の PageView のアイテム
  Widget get _buildEmptyPageItem {
    return _buildPageViewContainer(
      child: Center(
        child: Text(
          '周辺にデータが見つかりません。',
          style: grey12,
        ),
      ),
    );
  }
}
