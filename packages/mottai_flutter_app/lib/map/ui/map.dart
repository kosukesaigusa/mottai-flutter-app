import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../geolocator.dart';
import 'geolocator_controller.dart';

@RoutePage()
class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/map';

  /// [MapPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('マップ')),
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(35.681236, 139.767125),
            ),
          ),
          // 仮ボタン
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(
                        currentLocationControllerProvider,
                      )
                      .getCurrentPosition();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '現在地を取得',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ref.watch(currentPositionProvider).when(
                            data: (position) => Text('''
                              緯度: ${position.latitude}, 経度: ${position.longitude}
                            '''),
                            error: (_, __) => const SizedBox(),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
