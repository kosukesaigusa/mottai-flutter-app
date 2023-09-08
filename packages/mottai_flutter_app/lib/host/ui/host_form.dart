import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../development/firebase_storage/firebase_storage.dart';
import '../../development/firebase_storage/ui/firebase_storage_controller.dart';
import '../../host_location/ui/host_location_select_dialog.dart';
import '../../widgets/optional_badge.dart';
import 'host_controller.dart';

/// 東京駅の緯度経度（テスト用）初期位置は現在地？
const _tokyoStation = LatLng(35.681236, 139.767125);

/// 画像選択フィールドのエラーメッセージ
final imageFieldErrorStateProvider =
    StateProvider.autoDispose<String?>((_) => null);

/// ホストタイプフィールドのエラーメッセージ
final hostTypeErrorStateProvider =
    StateProvider.autoDispose<String?>((_) => null);

/// - `create` の場合、ログイン済みの `workerId`（ユーザー ID）
/// - `update` の場合、更新対象の [Host] とその本人であることが確認された `hostId`（ユーザー ID）
///
/// を受け取り、それに応じた [Host] の作成または更新を行うフォーム。
class HostForm extends ConsumerStatefulWidget {
  const HostForm.create({
    required String workerId,
    super.key,
  })  : _hostId = workerId,
        _host = null,
        _hostLocation = null;

  const HostForm.update({
    required String workerId,
    required ReadHost host,
    ReadHostLocation? location,
    super.key,
  })  : _hostId = workerId,
        _host = host,
        _hostLocation = location;

  final ReadHost? _host;

  final ReadHostLocation? _hostLocation;

  final String _hostId;

  @override
  HostFormState createState() => HostFormState();
}

class HostFormState extends ConsumerState<HostForm> {
  /// urlの最大数
  static const urlMaxCount = 5;

  /// フォームのグローバルキー
  final formKey = GlobalKey<FormState>();

  /// 選択中のホストタイプ
  final List<HostType> _selectedHostTypes = [];

  /// [Host.displayName] のテキストフィールド用コントローラー
  late final TextEditingController _nameController;

  /// [Host.introduction] のテキストフィールド用コントローラー
  late final TextEditingController _introductionController;

  /// [HostLocation.address] のテキストフィールド用コントローラー
  late final TextEditingController _locationController;

  /// [Host.urls]のテキストフィールド用コントローラー
  final List<TextEditingController> _urlControllers = [];

  /// [HostController] インスタンス
  late final HostController _controller;

  /// 選択中の [Geo]
  late Geo _geo;

  /// [GoogleMap] ウィジェットの `onMapCreated` で得られるコントローラインスタンス。
  late final GoogleMapController _googleMapController;

  /// Google Mapに記される [Marker].
  Set<Marker> _markers = {};

  /// [Geo] から [LatLng] に変換する関数
  LatLng _convertGeoToLatLng(Geo geo) {
    return LatLng(geo.geopoint.latitude, geo.geopoint.longitude);
  }

  /// [LatLng] から [Geo] に変換する関数
  Geo _convertLatLngToGeo(LatLng latLng) {
    final geoPoint = GeoPoint(
      latLng.latitude,
      latLng.longitude,
    );
    final geoFirePoint = GeoFirePoint(geoPoint);
    return Geo(
      geohash: geoFirePoint.geohash,
      geopoint: geoPoint,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget._host?.displayName);
    _introductionController =
        TextEditingController(text: widget._host?.introduction);
    _locationController =
        TextEditingController(text: widget._hostLocation?.address);
    for (var i = 0; i < urlMaxCount; i++) {
      _urlControllers
          .add(TextEditingController(text: widget._host?.urls.elementAt(i)));
    }

    _controller = ref.read(hostControllerProvider(widget._hostId));

    // ホストタイプ設定
    if (widget._host != null) {
      _selectedHostTypes.addAll(widget._host!.hostTypes.toList());
    }

    // ホスト所在設定
    final hostLocation = widget._hostLocation;
    if (hostLocation != null) {
      _geo = _convertLatLngToGeo(
        LatLng(
          hostLocation.geo.geopoint.latitude,
          hostLocation.geo.geopoint.longitude,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId(
            '(${_geo.geopoint.latitude}, ${_geo.geopoint.longitude})',
          ),
        ),
      );
    } else {
      _geo = _convertLatLngToGeo(
        _tokyoStation,
      );
      _markers.add(
        Marker(
          markerId: MarkerId(
            '(${_geo.geopoint.latitude}, ${_geo.geopoint.longitude})',
          ),
        ),
      );
    }
  }

  bool _validate(File? pickedImageFile) {
    final textValidate = formKey.currentState?.validate();
    final isExistImage =
        (pickedImageFile != null) || (widget._host?.imageUrl != null);
    final isSelectedHostType = _selectedHostTypes.isNotEmpty;

    var result = textValidate ?? true; // テキストの検証結果を代入(すべてのアンドをとるため)

    // エラーメッセージの初期化
    ref.watch(hostTypeErrorStateProvider.notifier).state = null;
    ref.watch(imageFieldErrorStateProvider.notifier).state = null;

    // 画像のチェック
    if (!isExistImage) {
      ref.watch(imageFieldErrorStateProvider.notifier).state = '画像を選択してください';
      result = false;
    }

    // ホストタイプのチェック
    if (!isSelectedHostType) {
      ref.watch(hostTypeErrorStateProvider.notifier).state =
          'ホストタイプを1つ以上選択してください';
      result = false;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStorageController =
        ref.watch(firebaseStorageControllerProvider);
    final pickedImageFile = ref.watch(pickedImageFileStateProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (pickedImageFile != null)
                              GestureDetector(
                                onTap: firebaseStorageController
                                    .pickImageFromGallery,
                                child: Container(
                                  height: 128,
                                  width: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(pickedImageFile),
                                    ),
                                  ),
                                ),
                              )
                            else if ((widget._host?.imageUrl ?? '').isNotEmpty)
                              GenericImage.circle(
                                onTap: firebaseStorageController
                                    .pickImageFromGallery,
                                showDetailOnTap: false,
                                imageUrl: pickedImageFile?.path ??
                                    widget._host!.imageUrl,
                                size: 64,
                              )
                            else
                              GestureDetector(
                                onTap: firebaseStorageController
                                    .pickImageFromGallery,
                                child: const Icon(
                                  Icons.account_circle_sharp,
                                  color: Color(0xFF323232),
                                  size: 128,
                                ),
                              ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _InputTextField(
                                  labelText: 'ホスト名',
                                  maxLines: 1,
                                  controller: _nameController,
                                  isRequired: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (ref.watch(imageFieldErrorStateProvider) != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ref.watch(imageFieldErrorStateProvider)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          )
                      ],
                    ),
                  ),
                  _TextInputSection(
                    title: '自己紹介',
                    defaultDisplayLines: 5,
                    controller: _introductionController,
                    isRequired: true,
                  ),
                  _TextInputSection.onlyChoice(
                    title: 'ホストタイプ',
                    description: 'ワーカーはホストタイプ（複数選択可）を参考にして、'
                        '興味のあるお手伝いを探します。',
                    choices: {
                      for (final v in HostType.values) v: v.label,
                    },
                    isRequired: true,
                    errorMessage: ref.watch(hostTypeErrorStateProvider),
                    enabledChoices: _selectedHostTypes,
                    onChoiceSelected: (item) {
                      if (_selectedHostTypes.contains(item)) {
                        _selectedHostTypes.remove(item);
                      } else {
                        _selectedHostTypes.add(item);
                      }
                      setState(() {});
                    },
                  ),
                  _TextInputSection(
                    title: '公開する場所・住所',
                    description: '農場や主な作業場所などの、公開される場所・住所です。'
                        'ワーカーは地図上から近所や興味がある地域のホストを探します。'
                        '必ずしも正確で細かい住所である必要はありません。',
                    controller: _locationController,
                    isRequired: true,
                  ),
                  _TextInputSection.onlyChild(
                    title: '地図上に表示する位置情報',
                    description: 'ワーカーはマップ上からお手伝いしたいホストを探します。'
                        '「地図を開く」から地図を開いて、あなたの農園や主な作業場所を長押ししてピンを立ててください。'
                        '必ずしも正確な位置を指定する必要はありません。',
                    isRequired: true,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 160,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _convertGeoToLatLng(
                                _geo,
                              ),
                              zoom: 20,
                            ),
                            markers: _markers,
                            onMapCreated: (controller) {
                              _googleMapController = controller;
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Marker? marker;
                            if (_markers.isNotEmpty) {
                              marker = _markers.first;
                            }
                            final geo = await showDialog<Geo>(
                              context: context,
                              builder: (context) => HostLocationSelectDialog(
                                initialCameraPosition: CameraPosition(
                                  target: _convertGeoToLatLng(
                                    _geo,
                                  ),
                                  zoom: 20,
                                ),
                                initialMarker: marker,
                              ),
                            );
                            if (geo != null) {
                              _geo = geo;

                              await _googleMapController.moveCamera(
                                CameraUpdate.newLatLng(
                                  _convertGeoToLatLng(
                                    _geo,
                                  ),
                                ),
                              );

                              final markers = <Marker>{}..add(
                                  Marker(
                                    markerId: MarkerId(
                                      '${_geo.geopoint.latitude},'
                                      '${_geo.geopoint.longitude}',
                                    ),
                                    position: _convertGeoToLatLng(_geo),
                                  ),
                                );
                              _markers = markers;
                              setState(() {});
                            }
                          },
                          child: const Text('地図を開く'),
                        ),
                      ],
                    ),
                  ),
                  Section(
                    title: 'URL',
                    titleBadge: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: OptionalBadge(),
                    ),
                    titleStyle: Theme.of(context).textTheme.titleLarge,
                    description: '農園や各種 SNS の URL があれば入力してください（最大 5 件）。',
                    descriptionStyle: Theme.of(context).textTheme.bodyMedium,
                    sectionPadding: const EdgeInsets.only(bottom: 32),
                    content: _VariableHeightGrid(
                      rowCount: 2,
                      children:
                          _urlControllers.asMap().entries.map<Widget>((entry) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: entry.value,
                            decoration: InputDecoration(
                              label: Text('URL(${entry.key + 1})'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_validate(pickedImageFile)) {
                            return;
                          }

                          if (widget._host != null) {
                            _controller.update(
                              hostId: widget._hostId,
                              displayName: _nameController.text,
                              introduction: _introductionController.text,
                              imageFile: pickedImageFile,
                              hostTypes: _selectedHostTypes.toSet(),
                              urls: _urlControllers
                                  .map((controller) => controller.text)
                                  .toList(),
                              address: _locationController.text,
                              geo: _geo,
                            );
                          } else {
                            _controller.create(
                              workerId: widget._hostId,
                              displayName: _nameController.text,
                              introduction: _introductionController.text,
                              imageFile: pickedImageFile!,
                              hostTypes: _selectedHostTypes.toSet(),
                              urls: _urlControllers
                                  .map((controller) => controller.text)
                                  .toList(),
                              address: _locationController.text,
                              geo: _geo,
                            );
                          }
                        },
                        child: const Text('この内容で登録する'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// タイトルと説明、テキストフィールドからなるセクション。
/// [Section] を使用し、`Section.content` にフィールドを与えている。
class _TextInputSection<T extends dynamic> extends StatelessWidget {
  /// テキスト入力のみをさせる通常の [_TextInputSection] を作成する。
  const _TextInputSection({
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.controller,
    this.isRequired = false,
    this.errorMessage,
    this.child,
  })  : choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// 選択肢のみの [_TextInputSection] を作成する。
  const _TextInputSection.onlyChoice({
    required this.title,
    this.description,
    required this.choices,
    required this.enabledChoices,
    required this.onChoiceSelected,
    this.isRequired = false,
    this.errorMessage,
    this.child,
  })  : defaultDisplayLines = 0,
        controller = null,
        maxLines = null;

  /// 選択肢のみの [_TextInputSection] を作成する。
  const _TextInputSection.onlyChild({
    required this.title,
    this.description,
    this.isRequired = false,
    this.errorMessage,
    required this.child,
  })  : defaultDisplayLines = 0,
        controller = null,
        maxLines = null,
        choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// セクションのタイトル。
  final String title;

  /// セクションの説明。
  final String? description;

  /// テキストフィールドの最大行数
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数
  final int defaultDisplayLines;

  /// テキストフィールドの下に表示する選択肢
  /// 選択された際の値がkeyで、表示する値がvalueの[Map]で受け取る。
  final Map<T, String> choices;

  /// [choices] の有効な値のリスト
  final List<T> enabledChoices;

  /// [choices] が選択された際のコールバック
  final void Function(T item)? onChoiceSelected;

  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  /// 必須入力か否か
  final bool isRequired;

  /// カスタム可能な子ウィジェット
  final Widget? child;

  /// エラーメッセージ
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Section(
      title: title,
      titleBadge: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: OptionalBadge(isRequired: isRequired),
      ),
      titleStyle: Theme.of(context).textTheme.bodyLarge,
      description: description,
      descriptionStyle: Theme.of(context).textTheme.bodyMedium,
      sectionPadding: const EdgeInsets.only(bottom: 32),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ],
          if (defaultDisplayLines > 0) ...[
            _InputTextField(
              controller: controller,
              maxLines: maxLines,
              isRequired: isRequired,
              defaultDisplayLines: defaultDisplayLines,
            ),
          ],
          if (choices.isNotEmpty) ...[
            const Gap(16),
            SelectableChips<T>(
              allItems: choices.keys,
              labels: choices,
              runSpacing: 8,
              enabledItems: enabledChoices,
              onTap: onChoiceSelected,
            ),
          ],
          if (child != null) ...[
            child!,
          ]
        ],
      ),
    );
  }
}

class _InputTextField extends StatelessWidget {
  const _InputTextField({
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.controller,
    this.isRequired = false,
    this.labelText,
  });

  /// テキストフィールドの最大行数
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数
  final int defaultDisplayLines;

  /// テキストフィールドのコントローラー
  final TextEditingController? controller;

  /// 必須入力か否か
  final bool isRequired;

  /// テキストフィールドのラベルテキスト
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (isRequired && (value ?? '').isEmpty) {
          return '入力してください。';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: List.filled(defaultDisplayLines - 1, '\n').join(),
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}

/// [TextField]をGridで表示するウィジェット
/// GridViewの場合は、aspect比を指定する必要があり、
/// [TextField]のような可変長aspect比が必要なウィジェットでは使用できないため作成
class _VariableHeightGrid extends StatelessWidget {
  const _VariableHeightGrid({
    required this.rowCount,
    required this.children,
  });

  final int rowCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = (children.length / rowCount).ceil();
        final columnWigets = <Widget>[];
        for (var i = 0; i < columnCount; i++) {
          final rowWigets = <Widget>[];
          for (var j = 0; j < rowCount; j++) {
            final targetIndex = j + i * rowCount;
            if (targetIndex < children.length) {
              rowWigets.add(
                LimitedBox(
                  maxWidth: constraints.maxWidth / rowCount,
                  maxHeight: constraints.maxHeight,
                  child: children[targetIndex],
                ),
              );
            }
          }

          columnWigets.add(
            Row(
              children: rowWigets,
            ),
          );
        }
        return Column(
          children: columnWigets,
        );
      },
    );
  }
}
