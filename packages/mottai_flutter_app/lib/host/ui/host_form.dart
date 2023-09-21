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
import '../../exception.dart';
import '../../host_location/ui/host_location_select_dialog.dart';
import '../../loading/ui/loading.dart';
import '../../scaffold_messenger_controller.dart';
import '../../widgets/optional_badge.dart';
import 'host_controller.dart';

// TODO: 現在の位置情報を反映する。
/// 東京駅の緯度経度（テスト用）初期位置は現在地？
const _tokyoStation = LatLng(35.681236, 139.767125);

class _ValidationException extends AppException {
  const _ValidationException({required String message})
      : super(message: message);
}

enum _HostFormMode { create, update }

/// - `create` の場合、ログイン済みの `workerId`（ユーザー ID）
/// - `update` の場合、更新対象の [Host] とその本人であることが確認された `hostId`（ユーザー ID）
///
/// を受け取り、それに応じた [Host] の作成または更新を行うフォーム。
class HostForm extends ConsumerStatefulWidget {
  const HostForm.create({
    required String hostId,
    super.key,
  })  : _hostId = hostId,
        _host = null,
        _hostLocation = null;

  const HostForm.update({
    required String hostId,
    required ReadHost host,
    ReadHostLocation? location,
    super.key,
  })  : _hostId = hostId,
        _host = host,
        _hostLocation = location;

  final ReadHost? _host;

  final ReadHostLocation? _hostLocation;

  final String _hostId;

  @override
  HostFormState createState() => HostFormState();
}

class HostFormState extends ConsumerState<HostForm> {
  /// フォームのモード。
  late final _HostFormMode _hostFormMode;

  /// 選択中のホストタイプ一覧。
  final List<HostType> _selectedHostTypes = [];

  /// [Host.displayName] のテキストフィールド用コントローラ。
  late final TextEditingController _nameController;

  /// [Host.introduction] のテキストフィールド用コントローラ。
  late final TextEditingController _introductionController;

  /// [HostLocation.address] のテキストフィールド用コントローラ。
  late final TextEditingController _locationController;

  /// [Host.urls] のテキストフィールド用コントローラ。
  final List<TextEditingController> _urlControllers = [];

  /// 選択中のホストの位置を表す [Geo].
  late Geo _geo;

  /// [GoogleMap] ウィジェットの `onMapCreated` で得られるコントローラインスタンス。
  late final GoogleMapController _googleMapController;

  /// [GoogleMap] 上に表示されるホストの位置を表す [Marker].
  Marker? _selectedMarker;

  /// [GoogleMap] 上に表示されるホストの位置を表す [Marker] の集合。
  Set<Marker> get _selectedMarkers =>
      _selectedMarker != null ? <Marker>{_selectedMarker!} : <Marker>{};

  /// [Geo] から [LatLng] に変換する関数
  LatLng _convertGeoToLatLng(Geo geo) =>
      LatLng(geo.geopoint.latitude, geo.geopoint.longitude);

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

  /// URL の最大数。
  static const _urlMaxCount = 5;

  @override
  void initState() {
    super.initState();
    _hostFormMode =
        widget._host != null ? _HostFormMode.update : _HostFormMode.create;
    _initializeTextEditingControllers();
    _selectedHostTypes.addAll((widget._host?.hostTypes ?? {}).toList());
    _initializeHostLocation();
  }

  /// 使用する [TextEditingController] を初期化する。
  void _initializeTextEditingControllers() {
    _nameController = TextEditingController(text: widget._host?.displayName);
    _introductionController =
        TextEditingController(text: widget._host?.introduction);
    _locationController =
        TextEditingController(text: widget._hostLocation?.address);
    for (var i = 0; i < _urlMaxCount; i++) {
      _urlControllers.add(
        TextEditingController(text: widget._host?.urls.elementAtOrNull(i)),
      );
    }
  }

  /// 選択されているホストの位置情報を初期化する。
  void _initializeHostLocation() {
    final hostLocation = widget._hostLocation;
    final latLng = hostLocation != null
        ? LatLng(
            hostLocation.geo.geopoint.latitude,
            hostLocation.geo.geopoint.longitude,
          )
        : _tokyoStation;
    _geo = _convertLatLngToGeo(latLng);
    _selectedMarker = Marker(
      markerId: MarkerId(
        '(${_geo.geopoint.latitude}, ${_geo.geopoint.longitude})',
      ),
    );
  }

  /// フォームの入力前にバリデーションを行い、不適切な場合には例外をスローする。
  void _validate() {
    if (ref.read(pickedImageFileStateProvider) == null) {
      throw const _ValidationException(message: '画像を選択してください。');
    }
    if (_nameController.text.isEmpty) {
      throw const _ValidationException(message: '名前を入力してください。');
    }
    if (_selectedHostTypes.isEmpty) {
      throw const _ValidationException(message: 'ホストタイプを選択してください。');
    }
    if (_introductionController.text.isEmpty) {
      throw const _ValidationException(message: '自己紹介を入力してください。');
    }
    if (_locationController.text.isEmpty) {
      throw const _ValidationException(message: '場所を入力してください。');
    }
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
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          const Gap(16),
                          Flexible(
                            child: _InputTextField(
                              labelText: 'ホスト名',
                              maxLines: 1,
                              controller: _nameController,
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                _InputSection.textField(
                  textEditingController: _introductionController,
                  title: '自己紹介',
                  defaultDisplayLines: 5,
                  isRequired: true,
                ),
                _InputSection.choices(
                  title: 'ホストタイプ',
                  description: 'ワーカーはホストタイプ（複数選択可）を参考にして、'
                      '興味のあるお手伝いを探します。',
                  choices: {
                    for (final v in HostType.values) v: v.label,
                  },
                  isRequired: true,
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
                _InputSection.textField(
                  textEditingController: _locationController,
                  title: '公開する場所・住所',
                  description: '農場や主な作業場所などの、公開される場所・住所です。'
                      'ワーカーは地図上から近所や興味がある地域のホストを探します。'
                      '必ずしも正確で細かい住所である必要はありません。',
                  isRequired: true,
                ),
                _InputSection.child(
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
                            zoom: 10,
                          ),
                          markers: _selectedMarkers,
                          onMapCreated: (controller) {
                            _googleMapController = controller;
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final geo = await Navigator.push<Geo>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HostLocationSelectPage(
                                initialCameraPosition: CameraPosition(
                                  target: _convertGeoToLatLng(
                                    _geo,
                                  ),
                                  zoom: 10,
                                ),
                                initialMarker: _selectedMarker,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                          if (geo == null) {
                            return;
                          }
                          _geo = geo;
                          await _googleMapController.moveCamera(
                            CameraUpdate.newLatLng(
                              _convertGeoToLatLng(
                                _geo,
                              ),
                            ),
                          );
                          _selectedMarker = Marker(
                            markerId: MarkerId(
                              '${_geo.geopoint.latitude}, '
                              '${_geo.geopoint.longitude}',
                            ),
                            position: _convertGeoToLatLng(_geo),
                          );
                          setState(() {});
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
                        ref
                            .read(overlayLoadingStateProvider.notifier)
                            .update((_) => true);
                        try {
                          _validate();
                          final controller =
                              ref.read(hostControllerProvider(widget._hostId));
                          switch (_hostFormMode) {
                            case _HostFormMode.create:
                              controller.create(
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
                            case _HostFormMode.update:
                              controller.update(
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
                          }
                        } on AppException catch (e) {
                          ref
                              .read(appScaffoldMessengerControllerProvider)
                              .showSnackBarByException(e);
                        } finally {
                          ref
                              .read(overlayLoadingStateProvider.notifier)
                              .update((_) => false);
                        }
                      },
                      child: const Text('この内容で登録する'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// タイトルと説明、テキストフィールドからなるセクション。
/// [Section] を使用し、`Section.content` にフィールドを与えている。
class _InputSection<T extends dynamic> extends StatelessWidget {
  /// テキスト入力のみをさせる通常の [_InputSection] を作成する。
  const _InputSection.textField({
    required this.textEditingController,
    required this.title,
    this.description,
    this.maxLines,
    this.defaultDisplayLines = 1,
    this.isRequired = false,
    this.child,
  })  : choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// 選択肢のみの [_InputSection] を作成する。
  const _InputSection.choices({
    required this.title,
    this.description,
    required this.choices,
    required this.enabledChoices,
    required this.onChoiceSelected,
    this.isRequired = false,
    this.child,
  })  : defaultDisplayLines = 0,
        textEditingController = null,
        maxLines = null;

  /// 任意の [child] を表示する [_InputSection] を作成する。
  const _InputSection.child({
    required this.title,
    this.description,
    this.isRequired = false,
    required this.child,
  })  : defaultDisplayLines = 0,
        textEditingController = null,
        maxLines = null,
        choices = const {},
        enabledChoices = const [],
        onChoiceSelected = null;

  /// セクションのタイトル。
  final String title;

  /// セクションの説明。
  final String? description;

  /// テキストフィールドの最大行数。
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数。
  final int defaultDisplayLines;

  /// テキストフィールドの下に表示する選択肢。
  /// 選択された際の値が key で、表示する値が value の [Map] で受け取る。
  final Map<T, String> choices;

  /// [choices] の有効な値のリスト。
  final List<T> enabledChoices;

  /// [choices] が選択された際のコールバック。
  final void Function(T item)? onChoiceSelected;

  /// テキストフィールドのコントローラ。
  final TextEditingController? textEditingController;

  /// 必須入力か否か。
  final bool isRequired;

  /// カスタム可能な子ウィジェット。
  final Widget? child;

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
          if (textEditingController != null)
            _InputTextField(
              controller: textEditingController,
              maxLines: maxLines,
              isRequired: isRequired,
              defaultDisplayLines: defaultDisplayLines,
            )
          else if (child != null)
            child!
          else if (choices.isNotEmpty)
            SelectableChips<T>(
              allItems: choices.keys,
              labels: choices,
              runSpacing: 8,
              enabledItems: enabledChoices,
              onTap: onChoiceSelected,
            ),
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

  /// テキストフィールドの最大行数。
  final int? maxLines;

  /// 初期表示時のテキストフィールドの行数。
  final int defaultDisplayLines;

  /// テキストフィールドのコントローラ。
  final TextEditingController? controller;

  /// 必須入力か否か
  final bool isRequired;

  /// テキストフィールドのラベルテキスト。
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}

/// [TextField] をGridで表示するウィジェッ。
/// GridView の場合は、aspect 比を指定する必要があり、
/// [TextField] のような可変長 aspect 比が必要なウィジェットでは使用できないため使用する。
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
        final columnWidgets = <Widget>[];
        for (var i = 0; i < columnCount; i++) {
          final rowWidgets = <Widget>[];
          for (var j = 0; j < rowCount; j++) {
            final targetIndex = j + i * rowCount;
            if (targetIndex < children.length) {
              rowWidgets.add(
                LimitedBox(
                  maxWidth: constraints.maxWidth / rowCount,
                  maxHeight: constraints.maxHeight,
                  child: children[targetIndex],
                ),
              );
            }
          }
          columnWidgets.add(Row(children: rowWidgets));
        }
        return Column(children: columnWidgets);
      },
    );
  }
}
